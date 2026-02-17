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
                Text(requestError.message)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                Button("Retry") {
                    Task { await viewModel.downloadPlaces() }
                }
            }
        }
        .padding()
    }
    
    var progressView: some View {
        ProgressView("Loading…")
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isLoading && viewModel.places.isEmpty {
                    progressView
                } else if let error = viewModel.requestError, viewModel.places.isEmpty {
                    errorView
                } else {
                    List(viewModel.places) { place in
                        VStack(alignment: .leading) {
                            Text(place.title)
                                .font(.headline)
                                .padding(.bottom)
                            
                            Text("Lat: \(place.latitude), Lon: \(place.longitude)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if let url = viewModel.generateURLFor(lat: place.latitude, long: place.longitude) {
                                UIApplication.shared.open(url)
                            }
                            
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Places")
            .task { await viewModel.downloadPlaces() }
        }
    }
}

#Preview {
    PlacesView()
}
