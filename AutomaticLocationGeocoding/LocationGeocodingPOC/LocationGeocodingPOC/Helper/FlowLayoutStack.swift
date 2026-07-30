//
//  FlowLayoutStack.swift
//  LocationGeocodingPOC
//
//  Created by Mamadou Balde on 7/22/26.
//

import SwiftUI

/// A custom horizontal layout container that displays an aligned collection of subviews.
///
/// This custom component provides scalable spacing constraints for wrapping micro-elements
/// such as tag lists, metadata icons, and short descriptive text elements.
///
/// ### Example Usage
/// ```swift
/// FlowLayoutStack(spacing: 12) {
///     Label("Building", systemImage: "building.2")
///     Label("Region", systemImage: "map")
/// }
/// ```
struct FlowLayoutStack<Content: View>: View {
    
    /// The exact spacing dimension padding applied between horizontally adjacent subviews.
    let spacing: CGFloat
    
    /// The combined, rendered view content closure embedded inside the layout stack.
    let content: Content
    
    /// Initializes a new layout instance with specific padding rules.
    /// - Parameters:
    ///   - spacing: The spacing layout inset distance between individual elements. Defaults to `8`.
    ///   - content: A ViewBuilder closure containing the structural elements to render horizontally.
    init(spacing: CGFloat = 8, @ViewBuilder content: () -> Content) {
        self.spacing = spacing
        self.content = content()
    }
    
    var body: some View {
        HStack(spacing: spacing) {
            content
        }
    }
}
