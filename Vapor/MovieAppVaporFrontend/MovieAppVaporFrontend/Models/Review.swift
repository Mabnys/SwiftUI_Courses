//
//  Review.swift
//  MovieAppVaporFrontend
//
//  Created by Mamadou Balde on 11/7/24.
//

import Foundation
// Review model matching the backend
struct Review: Identifiable, Codable {
    let id: UUID?
    let content: String
    let rating: Int
    let movieID: UUID
    
    enum CodingKeys: String, CodingKey {
        case id, content, rating
        case movieID = "movie_id"
    }
}
