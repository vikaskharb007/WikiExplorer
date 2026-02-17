//
//  ContentView.swift
//  WikiExplorer
//
//  Created by Vikas Kharb on 16/02/2026.
//

import SwiftUI

struct PlacesView: View {
    
    @StateObject private var viewModel = PlacesViewModel()

    var errorView: some View {
        return VStack(spacing: 12) {
            if let requestError = viewModel.requestError  {
                Text(requestError.title)
                    .font(.headline)
                    .accessibilityAddTraits(.isHeader)
                
                Text(requestError.errorDescription)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                
                Button("Retry") {
                    Task { await viewModel.downloadPlaces() }
                }
                .accessibilityHint("Attempts to download the place list again")
            }
        }
        .padding()
        .accessibilityElement(children: .combine)
    }
    
    var progressView: some View {
        ProgressView("Loading...")
            .accessibilityLabel("Loading places")
            .accessibilityAddTraits(.updatesFrequently)
    }
    
    var customLocationExploreButton: some View {
        NavigationLink {
            CustomLocationView()
        } label: {
            Label("Explore Custom Location", systemImage: "mappin.and.ellipse")
        }
        .accessibilityLabel("Explore Custom Location")
        .accessibilityHint("Opens a screen to enter coordinates manually")
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isLoading && viewModel.places.isEmpty {
                    progressView
                } else if viewModel.requestError != nil, viewModel.places.isEmpty {
                    errorView
                } else {
                    List(viewModel.places) { place in
                        Button {
                            Task {
                                await viewModel.connectToApp(latitude: place.latitude, longitude: place.longitude)
                            }
                        } label: {
                            PlacesViewRow(place: place)
                        }
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("\(place.title), Coordinates - \(place.displayCoordinates)")
                        .accessibilityHint("Opens in Wikipedia")
                    }
                    .listStyle(.plain)
                    
                    customLocationExploreButton
                }
            }
            .navigationTitle("Places")
            .onAppear {
                Task {
                    await viewModel.downloadPlaces()
                }
            }
        }
    }
}

#Preview {
    PlacesView()
}
