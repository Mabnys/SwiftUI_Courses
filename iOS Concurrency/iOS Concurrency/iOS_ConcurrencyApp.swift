//
//  iOS_ConcurrencyApp.swift
//  iOS Concurrency
//
//  Created by Mamadou Balde on 1/10/24.
//

import SwiftUI

@main
struct iOS_ConcurrencyApp: App {
    var body: some Scene {
        WindowGroup {
            UsersListView()
                .onAppear {
                    UserDefaults.standard.setValue(false, forKey: "_UIConstaintBasedLayoutLogUnsatisfisfiable") // this will fix the constraintError, if there is any.
                }
        }
    }
}
