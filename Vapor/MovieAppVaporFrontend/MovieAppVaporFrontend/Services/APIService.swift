//
//  APIService.swift
//  MovieAppVaporFrontend
//
//  Created by Mamadou Balde on 11/7/24.
//

import Foundation
import Combine

class APIService {
    private let baseURL = "http://localhost:8080/api/v1" // Update this to your Vapor server URL
    
    func fetchMovies() -> AnyPublisher<[Movie], Error> {
        let url = URL(string: "\(baseURL)/movies")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Movie].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
  func fetchReviews(for movieID: UUID) -> AnyPublisher<[Review], Error> {
      let url = URL(string: "\(baseURL)/reviews/movie/\(movieID)")!
      return URLSession.shared.dataTaskPublisher(for: url)
          .map(\.data)
          .decode(type: [Review].self, decoder: JSONDecoder())
          .eraseToAnyPublisher()
  }
}
