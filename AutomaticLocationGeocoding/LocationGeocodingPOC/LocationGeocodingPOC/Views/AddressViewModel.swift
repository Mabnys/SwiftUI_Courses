//
//  AddressViewModel.swift
//  LocationGeocodingPOC
//
//  Created by Mamadou Balde on 7/22/26.
//

import SwiftUI
import Combine

/// Defines the selectable data configurations for evaluating geocoding payloads.
enum TestVersion: String, CaseIterable, Identifiable {
    /// A small testing configuration containing exactly 3 mock records.
    case original3 = "3 Samples"
    
    /// A high-density configuration pulling data from a bundled asset file.
    case massFile = "Mass File JSON"
    
    var id: String { self.rawValue }
}

/// A state manager that orchestrates address fetching, dataset loading, and batch geocoding updates on the main thread.
@MainActor
class AddressViewModel: ObservableObject {
    // MARK: - Exposed UI State
    
    /// The currently active target data source selection configuration.
    ///
    /// Modifying this property triggers an automatic state change to refresh the loaded records array.
    @Published var selectedVersion: TestVersion = .original3 {
        didSet {
            loadSelectedDataset()
        }
    }
    
    /// Indicates whether a batch geocoding transaction is actively executing over the network.
    @Published var isLoading = false
    
    /// A descriptive string tracking current milestone updates during multi-batch tasks.
    @Published var progressMessage: String = ""
    
    /// The combined payload response containing all geospatial matches returned from the service.
    @Published var serverResponse: GeocodeResponse? = nil
    
    /// A string detailing execution errors if a network transaction or parsing step fails.
    @Published var errorMessage: String? = nil
    
    /// The raw array collection of address entries waiting to be geocoded.
    @Published var targetRecords: [AddressRecord] = []
    
    // MARK: - Dependencies
    
    /// The downstream networking service layer handling outbound endpoint serialization.
    private let geocodingService = GeocodingService()
    
    /// Prepares the view model by pulling down the initial baseline dataset.
    init() {
        loadSelectedDataset()
    }
    
    /// Switches tracking state parameters whenever the selector segment changes.
    ///
    /// Clears any lingering server responses or errors before loading the targeted data rows.
    func loadSelectedDataset() {
        self.errorMessage = nil
        self.serverResponse = nil
        
        switch selectedVersion {
        case .original3:
            loadOriginalThreeRecords()
        case .massFile:
            loadRecordsFromLargeJSONFile()
        }
    }
    
    // MARK: - Dataset Load Formats
    
    /// Seeds the model arrays with three hardcoded local address models.
    private func loadOriginalThreeRecords() {
        self.targetRecords = [
            AddressRecord(
                attributes: AddressAttributes(
                    objectId: 2966956,
                    street: "1 ECHO HILL",
                    city: "DOBBS FERRY",
                    state: "NY",
                    zip: "10522"
                )
            ),
            AddressRecord(
                attributes: AddressAttributes(
                    objectId: 25941,
                    street: "PO BOX 445",
                    city: "FISHKILL",
                    state: "NY",
                    zip: "125240445"
                )
            ),
            AddressRecord(
                attributes: AddressAttributes(
                    objectId: 4959541,
                    street: "1111 HOWARD ST",
                    city: "PEEKSKILL",
                    state: "NY",
                    zip: "10566"
                )
            )
        ]
        print("Loaded original 3 sample records.")
    }
    
    /// Attempts to load and parse historical rows from a bundled JSON configuration file.
    ///
    /// Logs error strings directly into the view layout if the asset cannot be uncovered or parsed.
    private func loadRecordsFromLargeJSONFile() {
        guard let fileURL = Bundle.main.url(forResource: "records", withExtension: "json") else {
            self.targetRecords = []
            self.errorMessage = "Error: 'records.json' file asset not found inside project bundle."
            return
        }
        
        do {
            let rawData = try Data(contentsOf: fileURL)
            // Use GeocodeRequest placeholder model wrapper structure to capture the root array element envelope
            let decodedPayload = try JSONDecoder().decode(GeocodeRequest.self, from: rawData)
            self.targetRecords = decodedPayload.records
            print("Successfully loaded \(targetRecords.count) mass entries from file framework.")
        } catch {
            self.targetRecords = []
            self.errorMessage = "Failed to parse JSON file asset: \(error.localizedDescription)"
            print("❌ File read validation error: \(error)")
        }
    }
    
    // MARK: - Execution Loops
    
    /// Iterates through total records array elements in automated loops of 2000 items.
    ///
    /// This function handles network transitions asynchronously, aggregates matching addresses,
    /// tracking progress checkpoints on the fly without locking the primary user interface threads.
    func sendDataInBatches() async {
        self.isLoading = true
        self.errorMessage = nil
        self.progressMessage = "Preparing items..."
        
        let chunkSize = 2000
        let totalRecords = targetRecords.count
        
        guard totalRecords > 0 else {
            self.errorMessage = "Cannot process an empty record queue."
            self.isLoading = false
            return
        }
        
        var combinedLocations: [GeocodeLocation] = []
        var finalSpatialReference: SpatialReference? = nil
        var finalURL: String? = nil
        
        defer { self.isLoading = false }
        
        for startIndex in stride(from: 0, to: totalRecords, by: chunkSize) {
            let endIndex = min(startIndex + chunkSize, totalRecords)
            let chunk = Array(targetRecords[startIndex..<endIndex])
            
            self.progressMessage = "Processing metrics \(startIndex + 1) to \(endIndex) of \(totalRecords)..."
            
            do {
                let response = try await geocodingService.geocode(records: chunk)
                
                if finalSpatialReference == nil {
                    finalSpatialReference = response.spatialReference
                    finalURL = response.requestURL
                }
                
                combinedLocations.append(contentsOf: response.locations)
            } catch {
                self.errorMessage = "Aborted at batch starting element \(startIndex + 1): \(error.localizedDescription)"
                return
            }
        }
        
        if let spatialRef = finalSpatialReference {
            self.serverResponse = GeocodeResponse(
                requestURL: finalURL,
                spatialReference: spatialRef,
                locations: combinedLocations
            )
        }
    }
    
    /// Resets runtime state fields, clearing active responses and error messages.
    func resetState() {
        self.serverResponse = nil
        self.errorMessage = nil
    }
}
