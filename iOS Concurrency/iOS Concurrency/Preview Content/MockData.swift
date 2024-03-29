//
//  MockData.swift
//  iOS Concurrency
//
//  Created by Mamadou Balde on 1/10/24.
//

import Foundation

extension User {
    static var mockUsers: [User] {
        Bundle.main.decode([User].self, from: "users.json")
    }
    static var mockSingleUser: User {
        Self.mockUsers[0]
    }
}

extension Post {
    static var mockPosts: [Post] {
        Bundle.main.decode([Post].self, from: "posts.json")
    }
    static var mockSinglePost: Post {
        Self.mockPosts[0]
    }
    
    static var mockSingleUsersPostsArray: [Post] {
        Self.mockPosts.filter { $0.userId == 1}
    }
}

extension UserAndPosts {
    static var mockUsersAndPosts: [UserAndPosts] {
        var newUsersAndPosts: [UserAndPosts] = []
        for user in User.mockUsers {
            let newUserAndPosts = UserAndPosts(user: user, posts: Post.mockPosts.filter {$0.userId == user.id})
            newUsersAndPosts.append(newUserAndPosts)
        }
        return newUsersAndPosts
    }
}
