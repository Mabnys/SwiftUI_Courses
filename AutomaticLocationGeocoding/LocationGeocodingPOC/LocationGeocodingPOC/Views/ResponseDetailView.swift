//
//  ResponseDetailView.swift
//  LocationGeocodingPOC
//
//  Created by Mamadou Balde on 7/22/26.
//

import SwiftUI

/// A view that displays the detailed results of a geocoding network response.
///
/// This component presents an overview of the server transaction, breaking down data into three core areas:
/// 1. An interactive query URL card featuring haptic clipboard copying.
/// 2. Spatial reference metadata (WKID / EPSG tracking details).
/// 3. A list of layout matches accompanied by their accuracy ratings and location metrics.
struct ResponseDetailView: View {
    
    /// The decoded geocoding payload data displayed in the interface.
    let response: GeocodeResponse
    
    /// A state variable determining if the server's request URL was successfully copied to the user's pasteboard.
    @State private var isCopied = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                // 1. Fully Formed Formatted Request URL Card Display
                if let fullURL = response.requestURL {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Label("Formed Query URL", systemImage: "link.circle.fill")
                                .font(.caption)
                                .bold()
                                .foregroundColor(.blue)
                            Spacer()
                            
                            // Interactive Animated Copy Button
                            Button(action: {
                                UIPasteboard.general.string = fullURL
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                
                                withAnimation(.spring(response: 0.1, dampingFraction: 0.6)) {
                                    isCopied = true
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        isCopied = false
                                    }
                                }
                            }) {
                                Text(isCopied ? "COPIED!" : "TAP TO COPY")
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundColor(isCopied ? .green : .primary)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(isCopied ? Color.green.opacity(0.15) : Color(.separator))
                                    .cornerRadius(4)
                                    .scaleEffect(isCopied ? 1.15 : 1.0)
                            }
                            .buttonStyle(.plain)
                            .disabled(isCopied)
                        }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            Text(fullURL)
                                .font(.system(.caption2, design: .monospaced))
                                .foregroundColor(.primary)
                                .padding(.vertical, 4)
                                .textSelection(.enabled)
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                
                // 2. Spatial Reference Information Card
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Spatial Reference")
                            .font(.headline)
                        // Displays the current and updated coordinate system IDs to the user
                        Text("WKID: \(response.spatialReference.wkid) (Latest: \(response.spatialReference.latestWkid))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Image(systemName: "globe.americas.fill")
                        .foregroundColor(.blue)
                        .font(.title)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // 3. Header Title for Output Records
                Text("Geocoded Matches (\(response.locations.count))")
                    .font(.title3)
                    .bold()
                    .padding(.horizontal)
                    .padding(.top, 8)
                
                // 4. Custom Collection Stack of Geocoded Layout Matches
                ForEach(0..<response.locations.count, id: \.self) { index in
                    let location = response.locations[index]
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(alignment: .top) {
                            Text(location.address)
                                .font(.headline)
                                .fixedSize(horizontal: false, vertical: true)
                            Spacer()
                            
                            // Clean standalone sub-expressions block layout rules
                            if location.score == 100 {
                                Text("Score: \(location.score)")
                                    .font(.caption2)
                                    .bold()
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.green.opacity(0.15))
                                    .foregroundColor(.green)
                                    .cornerRadius(8)
                            } else {
                                Text("Score: \(location.score)")
                                    .font(.caption2)
                                    .bold()
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.orange.opacity(0.15))
                                    .foregroundColor(.orange)
                                    .cornerRadius(8)
                            }
                        }
                        
                        Divider()
                        
                        HStack(spacing: 4) {
                            Text("Coordinates (X/Y):")
                                .foregroundColor(.secondary)
                            Text("\(location.location.x, specifier: "%.4f"), \(location.location.y, specifier: "%.4f")")
                                .bold()
                        }
                        .font(.subheadline)
                        
                        // Clean, safely unwrapped metadata label rows
                        FlowLayoutStack(spacing: 12) {
                            let attrType = location.attributes.type
                            Label {
                                Text(attrType.isEmpty ? "Unknown Type" : attrType)
                            } icon: {
                                Image(systemName: "building.2")
                            }
                            
                            let attrSub = location.attributes.subregion
                            Label {
                                Text(attrSub.isEmpty ? "Unknown Area" : attrSub)
                            } icon: {
                                Image(systemName: "map")
                            }
                            
                            let attrCountry = location.attributes.countryName
                            Label {
                                Text(attrCountry.isEmpty ? "USA" : attrCountry)
                            } icon: {
                                Image(systemName: "flag")
                            }
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.separator), lineWidth: 0.5)
                    )
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
    }
}
