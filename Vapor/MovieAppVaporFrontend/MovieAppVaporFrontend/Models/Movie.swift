//
//  Movie.swift
//  MovieAppVaporFrontend
//
//  Created by Mamadou Balde on 11/7/24.
//

import Foundation

// Movie model matching the backend
struct Movie: Identifiable, Codable {
  let id: UUID?
  let tmdbId: Int
  let title: String
  let overview: String
  let releaseDate: String
  let voteAverage: Double
  var reviews: [Review]?
  
  enum CodingKeys: String, CodingKey {
    case id, tmdbId, title, overview, releaseDate, voteAverage, reviews
  }
}
