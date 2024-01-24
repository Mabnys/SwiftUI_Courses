//
//  User.swift
//  iOS Concurrency
//
//  Created by Mamadou Balde on 1/10/24.
//

import Foundation

// Source: https://jsonplaceholder.typicode.com/users
// Data Object (value type)
struct User: Codable, Identifiable {
    let id: Int
    let name: String
    let username: String
    let email: String
}
