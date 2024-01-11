//
//  APIService.swift
//  iOS Concurrency
//
//  Created by Mamadou Balde on 1/10/24.
//

import Foundation
// This is reusable for future projects
struct APIService {
    let urlString: String
    
    func getJSON<T: Decodable>(dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                               keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) async throws -> T {
        guard let url = URL(string: urlString)
        else {
            throw APIError.invalidURL
        }
        do {
            //Since our function is asynchronous, and we have no idea how long data & response (tuple) will come back, thus, we need to wait it before we move on in our code. And we do this, by adding await after try.
            let (data, response) = try await URLSession.shared.data(from: url) // try await, the order matters.
            guard let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 200
            else {
                throw APIError.invalidResponseStatus
            }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = dateDecodingStrategy
            decoder.keyDecodingStrategy = keyDecodingStrategy
            do {
                let decodeData = try decoder.decode(T.self, from: data)
                return decodeData
            } catch {
                throw APIError.decodingError(error.localizedDescription)
            }
        } catch {
            throw APIError.dataTaskError(error.localizedDescription)
        }
    }
  
    // It's an asynchronous func that's executing on a background thread. It is also a generic function to handle the different API endpoints and models, and use a Result based completion handler with our designed API error.
    func getJSON<T: Decodable>(dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                               keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
                               completion: @escaping (Result<T,APIError>) -> Void) {
        guard let url = URL(string: urlString)
        else {
            completion(.failure(.invalidURL))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 200
            else {
                completion(.failure(.invalidResponseStatus))
                return
            }
            guard error == nil
            else {
                completion(.failure(.dataTaskError(error!.localizedDescription)))
                return
            }
            guard let data = data
            else {
                completion(.failure(.corruptData))
                return
            }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = dateDecodingStrategy
            decoder.keyDecodingStrategy = keyDecodingStrategy
            do {
                let decodeData = try decoder.decode(T.self, from: data)
                completion(.success(decodeData))
            } catch {
                completion(.failure(.decodingError(error.localizedDescription)))
            }
        }
        .resume()
    }
}

enum APIError: Error, LocalizedError { // this is an Enum Associated Values
    case invalidURL
    case invalidResponseStatus
    case dataTaskError(String)
    case corruptData
    case decodingError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("The endpoint URL is invalid", comment: "")
        case .invalidResponseStatus:
            return NSLocalizedString("The APIO failed to issue a valid response", comment: "")
        case .dataTaskError(let string):
            return string
        case .corruptData:
            return NSLocalizedString("The data provided appears to be corrupt", comment: "")
        case .decodingError(let string):
            return string
        }
    }
}
