//
//  ContentView.swift
//  LocationGeocodingPOC
//
//  Created by Mamadou Balde on 7/22/26.
//

import SwiftUI

/// The root view wrapper establishing the entry point interface layout for the application.
///
/// This structurally simple container isolates the primary lifecycle rendering loop, embedding
/// the main ``AddressFormView`` interface within its frame bounds.
struct ContentView: View {
    var body: some View {
        AddressFormView()
    }
}

#Preview {
    ContentView()
}
