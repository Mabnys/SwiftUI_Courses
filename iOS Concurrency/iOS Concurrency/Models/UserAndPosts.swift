//
//  UserAndPosts.swift
//  iOS Concurrency
//
//  Created by Mamadou Balde on 1/11/24.
//

import Foundation
// Data Object (value type)
struct UserAndPosts: Identifiable {
    var id = UUID()
    let user: User
    let posts: [Post]
    var numberOfPosts: Int {
        posts.count
    }
}
