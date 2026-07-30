//
//  GeocodingService.swift
//  LocationGeocodingPOC
//
//  Created by Mamadou Balde on 7/22/26.
//

import Foundation
import os.log

/// Handles communication with the NYS GeoHub ArcGIS batch geocoding service,
/// including request construction, response decoding, chunked batch processing,
/// and resilience against transient server-side failures via automatic retry
/// with exponential backoff.
///
/// The NYS GeoHub locator advertises a `MaxBatchSize`/`SuggestedBatchSize` of
/// 1000 and a `LoadBalancerTimeOut` of 60 seconds. In practice, requests near
/// the maximum batch size risk exceeding that timeout under shared server load,
/// which surfaces as an intermittent, generic `400` "Unable to complete
/// operation" error even for valid payloads. This service therefore chunks
/// large record sets into smaller batches, throttles between chunks, and logs
/// per-chunk timing to help tune the batch size empirically.
struct GeocodingService {
    private let baseURL = "https://nysgeohub.ny.gov/arcgis/rest/services/Geocoder/NYS_Geocoder/GeocodeServer/geocodeAddresses"
    private let logger = Logger(subsystem: "LocationGeocodingPOC", category: "GeocodingService")

    /// Configuration for the retry/backoff strategy applied to transient failures.
    struct RetryConfiguration {
        /// Maximum number of attempts, including the initial attempt.
        var maxAttempts: Int = 4
        /// Base delay (in seconds) used to compute exponential backoff.
        var baseDelay: TimeInterval = 2.0
        /// Multiplier applied per additional attempt (2.0 = classic doubling).
        var backoffFactor: Double = 2.0
        /// Upper bound on any single computed delay, to avoid unbounded waits.
        var maxDelay: TimeInterval = 20.0
        /// HTTP status codes considered retryable (server/rate-limit errors).
        var retryableStatusCodes: Set<Int> = [429, 500, 502, 503, 504]
        /// ArcGIS `extendedCode` values known to be transient rather than payload errors.
        var retryableExtendedCodes: Set<Int> = [-2147467259]
    }

    /// Configuration for splitting large record sets into locator-safe batches.
    struct BatchConfiguration {
        /// Number of records per outbound request. Kept comfortably below the
        /// locator's advertised `MaxBatchSize` of 1000 to stay within the
        /// 60-second `LoadBalancerTimeOut` under typical shared-server load.
        var chunkSize: Int = 500
        /// Delay between successive chunk requests to avoid overwhelming the
        /// shared public locator.
        var interChunkDelay: TimeInterval = 0.5
        /// Minimum chunk size at which bisection fallback stops splitting and
        /// surfaces the underlying error instead (isolates a single bad record).
        var minimumBisectionSize: Int = 1
    }

    private let retryConfiguration: RetryConfiguration
    private let batchConfiguration: BatchConfiguration

    /// Creates a geocoding service instance.
    /// - Parameters:
    ///   - retryConfiguration: Retry/backoff behavior for transient failures. Defaults to a 4-attempt exponential backoff.
    ///   - batchConfiguration: Chunking behavior for large record sets. Defaults to 500-record chunks.
    init(retryConfiguration: RetryConfiguration = RetryConfiguration(), batchConfiguration: BatchConfiguration = BatchConfiguration()) {
        self.retryConfiguration = retryConfiguration
        self.batchConfiguration = batchConfiguration
    }

    /// Geocodes an arbitrarily large set of records by splitting them into
    /// locator-safe chunks, processing each sequentially, and falling back to
    /// bisection when a chunk exhausts all retry attempts.
    ///
    /// Each chunk's wall-clock duration is logged so you can empirically tune
    /// ``BatchConfiguration/chunkSize`` against the locator's 60-second
    /// `LoadBalancerTimeOut`. A short delay is inserted between chunks to
    /// avoid overwhelming the shared public service.
    ///
    /// - Parameters:
    ///   - records: The full set of address records to geocode, of any size.
    ///   - outSR: The output spatial reference well-known ID. Defaults to `"4326"` (WGS84).
    ///   - f: The response format. Defaults to `"json"`.
    /// - Returns: An array of ``GeocodeResponse`` values, one per successfully processed chunk (or sub-chunk after bisection).
    /// - Throws: The underlying error from a chunk that fails even after bisection down to a single record.
    func geocodeAll(records: [AddressRecord], outSR: String = "4326", f: String = "json") async throws -> [GeocodeResponse] {
        var results: [GeocodeResponse] = []
        let chunks = records.chunked(into: batchConfiguration.chunkSize)

        for (index, chunk) in chunks.enumerated() {
            let chunkResults = try await geocodeChunkWithBisection(chunk, outSR: outSR, f: f, chunkLabel: "\(index + 1)/\(chunks.count)")
            results.append(contentsOf: chunkResults)

            if index < chunks.count - 1 {
                try await Task.sleep(for: .milliseconds(Int(batchConfiguration.interChunkDelay * 1000)))
            }
        }

        return results
    }

    /// Attempts to geocode a single chunk, recursively bisecting it into
    /// smaller sub-chunks if the chunk fails even after all retries are
    /// exhausted. This isolates a single malformed record without stalling
    /// the entire batch pipeline.
    ///
    /// - Parameters:
    ///   - chunk: The records to geocode in this chunk.
    ///   - outSR: The output spatial reference well-known ID.
    ///   - f: The response format.
    ///   - chunkLabel: A human-readable label used for logging (e.g. `"3/25"`).
    /// - Returns: One or more ``GeocodeResponse`` values covering the chunk (multiple if bisection occurred).
    /// - Throws: The underlying error if bisection reaches ``BatchConfiguration/minimumBisectionSize`` and still fails.
    private func geocodeChunkWithBisection(_ chunk: [AddressRecord], outSR: String, f: String, chunkLabel: String) async throws -> [GeocodeResponse] {
        let startTime = Date()
        do {
            let response = try await geocode(records: chunk, outSR: outSR, f: f)
            let elapsed = Date().timeIntervalSince(startTime)
            logger.info("Chunk \(chunkLabel, privacy: .public) succeeded: \(chunk.count, privacy: .public) records in \(elapsed, privacy: .public)s")
            return [response]
        } catch {
            let elapsed = Date().timeIntervalSince(startTime)
            logger.error("Chunk \(chunkLabel, privacy: .public) failed after \(elapsed, privacy: .public)s: \(error.localizedDescription, privacy: .public)")

            guard chunk.count > batchConfiguration.minimumBisectionSize else {
                throw error
            }

            let midpoint = chunk.count / 2
            let firstHalf = Array(chunk[..<midpoint])
            let secondHalf = Array(chunk[midpoint...])

            logger.info("Bisecting chunk \(chunkLabel, privacy: .public) into \(firstHalf.count, privacy: .public) + \(secondHalf.count, privacy: .public)")

            var bisectedResults: [GeocodeResponse] = []
            bisectedResults.append(contentsOf: try await geocodeChunkWithBisection(firstHalf, outSR: outSR, f: f, chunkLabel: "\(chunkLabel).a"))
            bisectedResults.append(contentsOf: try await geocodeChunkWithBisection(secondHalf, outSR: outSR, f: f, chunkLabel: "\(chunkLabel).b"))
            return bisectedResults
        }
    }

    /// Executes the geocoding operation against the NYS GeoHub service and returns a hydrated model with its request URL.
    ///
    /// This method automatically retries on transient network errors, retryable HTTP status codes,
    /// and known-transient ArcGIS server error codes (e.g. `-2147467259`), using exponential backoff
    /// with jitter between attempts. Non-transient errors (e.g. malformed payload, permanent 4xx client
    /// errors) are thrown immediately without retrying.
    ///
    /// - Parameters:
    ///   - records: The address records to geocode. Should not exceed the locator's `MaxBatchSize` (1000).
    ///   - outSR: The output spatial reference well-known ID. Defaults to `"4326"` (WGS84).
    ///   - f: The response format. Defaults to `"json"`.
    /// - Returns: A decoded ``GeocodeResponse`` with `requestURL` populated for UI display.
    /// - Throws: `URLError.badURL` if the request could not be constructed, or an `NSError` in the
    ///   `"ArcGISServerError"` domain if the server returned a non-transient error, or the last
    ///   encountered error after all retry attempts are exhausted.
    func geocode(records: [AddressRecord], outSR: String = "4326", f: String = "json") async throws -> GeocodeResponse {
        guard let request = buildRequest(records: records, outSR: outSR, f: f) else {
            throw URLError(.badURL)
        }

        let fullyFormedURLString = buildVisualURLString(records: records, outSR: outSR, f: f)

        let data = try await performWithRetry(request: request)

        // Trace and Intercept Explicit ArcGIS Server Error Blocks
        if let serverError = try? JSONDecoder().decode(GeocodeServerError.self, from: data) {
            let detailReason = serverError.error.details?.joined(separator: " ") ?? serverError.error.message
            throw NSError(domain: "ArcGISServerError", code: serverError.error.code, userInfo: [NSLocalizedDescriptionKey: "Server Message: \(detailReason)"])
        }

        var decodedResponse = try JSONDecoder().decode(GeocodeResponse.self, from: data)
        decodedResponse.requestURL = fullyFormedURLString

        return decodedResponse
    }

    /// Performs the network request with automatic retry and exponential backoff for transient failures.
    ///
    /// On each attempt, the response is inspected for:
    /// 1. Retryable HTTP status codes (`429`, `500`, `502`, `503`, `504`).
    /// 2. A known-transient ArcGIS `extendedCode` embedded in an otherwise well-formed error body
    ///    (e.g. `-2147467259`, "Unable to complete operation").
    ///
    /// If neither condition is met, the response (success or permanent failure) is returned/thrown
    /// immediately. Delay between attempts grows exponentially and includes random jitter to avoid
    /// synchronized retry storms against the shared public locator.
    ///
    /// - Parameter request: The fully constructed `URLRequest` to execute.
    /// - Returns: The raw response `Data` from a successful or non-retryable attempt.
    /// - Throws: The last encountered error if all attempts are exhausted.
    private func performWithRetry(request: URLRequest) async throws -> Data {
        var lastError: Error = URLError(.unknown)

        for attempt in 0..<retryConfiguration.maxAttempts {
            do {
                let (data, response) = try await URLSession.shared.data(for: request)

                if let httpResponse = response as? HTTPURLResponse,
                   retryConfiguration.retryableStatusCodes.contains(httpResponse.statusCode) {
                    lastError = NSError(
                        domain: "ArcGISServerError",
                        code: httpResponse.statusCode,
                        userInfo: [NSLocalizedDescriptionKey: "Retryable HTTP status \(httpResponse.statusCode)"]
                    )
                    try await waitBeforeNextAttempt(attempt: attempt)
                    continue
                }

                if let serverError = try? JSONDecoder().decode(GeocodeServerError.self, from: data),
                   retryConfiguration.retryableExtendedCodes.contains(serverError.error.extendedCode ?? serverError.error.code) {
                    lastError = NSError(
                        domain: "ArcGISServerError",
                        code: serverError.error.code,
                        userInfo: [NSLocalizedDescriptionKey: serverError.error.message]
                    )
                    try await waitBeforeNextAttempt(attempt: attempt)
                    continue
                }

                // Success or non-retryable outcome: hand it back to the caller as-is.
                return data
            } catch {
                lastError = error
                try await waitBeforeNextAttempt(attempt: attempt)
            }
        }

        throw lastError
    }

    /// Suspends the current task for an exponentially increasing, jittered delay based on the attempt index.
    ///
    /// - Parameter attempt: The zero-based index of the attempt that just failed.
    /// - Throws: `CancellationError` if the enclosing task is cancelled during the sleep.
    private func waitBeforeNextAttempt(attempt: Int) async throws {
        let exponentialDelay = retryConfiguration.baseDelay * pow(retryConfiguration.backoffFactor, Double(attempt))
        let cappedDelay = min(exponentialDelay, retryConfiguration.maxDelay)
        let jitteredDelay = Double.random(in: (cappedDelay * 0.5)...cappedDelay)
        try await Task.sleep(for: .milliseconds(Int(jitteredDelay * 1000)))
    }

    /// Compiles the operational URLRequest payload mirroring Postman's distinct URL vs Body layout.
    ///
    /// - Parameters:
    ///   - records: The address records to encode into the request body.
    ///   - outSR: The output spatial reference well-known ID.
    ///   - f: The response format.
    /// - Returns: A fully configured `URLRequest`, or `nil` if URL construction or JSON encoding fails.
    private func buildRequest(records: [AddressRecord], outSR: String, f: String) -> URLRequest? {
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.queryItems = [
            URLQueryItem(name: "outSR", value: outSR),
            URLQueryItem(name: "f", value: f),
            URLQueryItem(name: "matchOutOfRange", value: "true")
        ]

        guard let finalURL = urlComponents?.url else { return nil }

        var request = URLRequest(url: finalURL)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]

        guard let jsonData = try? encoder.encode(GeocodeRequest(records: records)),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            return nil
        }

        let customEscapedAllowedSet = CharacterSet(charactersIn: "=\"#%/<>?@\\^`{|}[]*+,").inverted
        guard let escapedJsonString = jsonString.addingPercentEncoding(withAllowedCharacters: customEscapedAllowedSet) else {
            return nil
        }

        let bodyString = "addresses=\(escapedJsonString)"
        request.httpBody = bodyString.data(using: .utf8)

        return request
    }

    /// Generates the absolute visual URL string representation with all parameters visible for UI copy tracking.
    ///
    /// - Parameters:
    ///   - records: The address records to encode for display purposes.
    ///   - outSR: The output spatial reference well-known ID.
    ///   - f: The response format.
    /// - Returns: A human-readable URL string suitable for display/copy in the UI, falling back to `baseURL` on failure.
    private func buildVisualURLString(records: [AddressRecord], outSR: String, f: String) -> String {
        guard var components = URLComponents(string: baseURL) else { return baseURL }

        let visualEncoder = JSONEncoder()
        visualEncoder.outputFormatting = [.prettyPrinted, .sortedKeys]

        guard let jsonData = try? visualEncoder.encode(GeocodeRequest(records: records)),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            return baseURL
        }

        components.queryItems = [
            URLQueryItem(name: "addresses", value: jsonString),
            URLQueryItem(name: "category", value: ""),
            URLQueryItem(name: "sourceCountry", value: ""),
            URLQueryItem(name: "matchOutOfRange", value: "true"),
            URLQueryItem(name: "langCode", value: ""),
            URLQueryItem(name: "locationType", value: ""),
            URLQueryItem(name: "searchExtent", value: ""),
            URLQueryItem(name: "outSR", value: outSR),
            URLQueryItem(name: "outFields", value: ""),
            URLQueryItem(name: "preferredLabelValues", value: ""),
            URLQueryItem(name: "f", value: f)
        ]

        return components.url?.absoluteString ?? baseURL
    }
}

/// Utility extension for splitting a large array into fixed-size chunks.
private extension Array {
    /// Splits the array into consecutive subarrays of at most `size` elements each.
    /// - Parameter size: The maximum number of elements per chunk.
    /// - Returns: An array of subarrays, preserving original order.
    func chunked(into size: Int) -> [[Element]] {
        guard size > 0 else { return [self] }
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}
