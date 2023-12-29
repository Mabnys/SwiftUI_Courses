//
//  CalculatorSwiftUIApp.swift
//  CalculatorSwiftUI
//
//  Created by Mamadou Balde on 12/29/23.
//

import SwiftUI

@main
struct CalculatorSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            // Create the SwiftUI view that provides the window contents
            ContentView().environmentObject(GlobalEnvironment())
        }
    }
}
