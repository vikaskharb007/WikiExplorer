//
//  PlacesViewModel.swift
//  WikiExplorer
//
//  Created by Vikas Kharb on 16/02/2026.
//

import Combine
import Foundation

final class PlacesViewModel: ObservableObject {
    @Published private(set) var places: [Place] = []
    @Published private(set) var isLoading: Bool = false
    @Published var requestError: NetworkRequestError?
    
    private let repository: PlacesRepositoryProtocol

    init(placesRepository: PlacesRepositoryProtocol = PlacesRepository()) {
        self.repository = placesRepository
    }
    
    func downloadPlaces() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        
        do {
            self.places = try await repository.downloadPlaces()
            self.requestError = nil
        } catch {
            self.requestError = error as? NetworkRequestError
        }
    }
    
    func generateURLFor(lat: Double, long: Double) -> URL? {
        guard let compiledURL = URL(string: "wikipedia://places?coordinates=\(lat),\(long)") else {
            return nil
        }
        
        return compiledURL
    }
}

