//
//  AddressFormView.swift
//  LocationGeocodingPOC
//
//  Created by Mamadou Balde on 7/22/26.
//

import SwiftUI

/// A primary layout interface providing control toggles and processing actions for batch geocoding.
///
/// This view binds directly to an ``AddressViewModel`` instance on the main actor to render:
/// 1. A segmented picker interface allowing testing across distinct mock or local storage data sets.
/// 2. Live progress telemetry updates indicating loading stages, validation metrics, or crash reports.
/// 3. A structured subheadline data view displaying target addresses and item sequences.
/// 4. A prominent navigation execution switch pushing computed array matrix results forward into a ``ResponseDetailView``.
struct AddressFormView: View {
    
    /// The standalone state source tracking dataset parameters, processing loops, and server response states.
    @StateObject private var viewModel = AddressViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                // Toggle Segmented Header Row
                VStack(spacing: 12) {
                    Picker("Test Version", selection: $viewModel.selectedVersion) {
                        ForEach(TestVersion.allCases) { version in
                            Text(version.rawValue).tag(version)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Active Parameters (outSR: 4326)")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            
                            if let error = viewModel.errorMessage {
                                Text(error)
                                    .font(.caption2)
                                    .bold()
                                    .foregroundColor(.red)
                            } else if viewModel.isLoading {
                                HStack(spacing: 6) {
                                    ProgressView().tint(.blue)
                                    Text(viewModel.progressMessage)
                                        .font(.caption2)
                                        .bold()
                                        .foregroundColor(.blue)
                                }
                            } else {
                                Text("Queue Ready for processing transaction actions.")
                                    .font(.caption2)
                                    .foregroundColor(.green)
                            }
                        }
                        Spacer()
                        Text("\(viewModel.targetRecords.count) Items")
                            .font(.caption)
                            .bold()
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(6)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                
                Divider()
                
                // Dynamic Items Listing
                if viewModel.targetRecords.isEmpty {
                    VStack(spacing: 12) {
                        Spacer()
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.largeTitle)
                            .foregroundColor(.secondary)
                        Text("No Address Data Loaded")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                } else {
                    List(viewModel.targetRecords, id: \.attributes.objectId) { record in
                        HStack(spacing: 12) {
                            Text("\(record.attributes.objectId)")
                                .font(.system(.caption2, design: .monospaced))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 3)
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .cornerRadius(4)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(record.attributes.street).font(.subheadline).bold()
                                Text("\(record.attributes.city), \(record.attributes.state) \(record.attributes.zip)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 2)
                    }
                }
                
                Divider()
                
                // Main Process Action Button Component
                Button(action: {
                    Task {
                        await viewModel.sendDataInBatches()
                    }
                }) {
                    HStack {
                        if viewModel.isLoading {
                            Text("Processing Matrix Items...")
                                .bold()
                        } else {
                            Image(systemName: "bolt.fill")
                            Text("Process \(viewModel.targetRecords.count) Records")
                                .bold()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                }
                .buttonStyle(.borderedProminent)
                .padding()
                .disabled(viewModel.isLoading || viewModel.targetRecords.isEmpty)
            }
            .navigationTitle("NYS Batch Geocoder")
            .navigationDestination(item: $viewModel.serverResponse) { response in
                ResponseDetailView(response: response)
            }
        }
    }
}
