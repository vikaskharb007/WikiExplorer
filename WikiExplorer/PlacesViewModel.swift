//
//  PlacesViewModel.swift
//  WikiExplorer
//
//  Created by Vikas Kharb on 16/02/2026.
//

import Foundation
internal import Combine

struct LocationsResponse: Decodable {
    let locations: [Place]
}

final class PlacesViewModel: ObservableObject {
    @Published private(set) var places: [Place] = []
    @Published private(set) var isLoading: Bool = false
    @Published var requestError: NetworkRequestError?

    private let requestURL = "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json"

    init() {}
    
    func downloadPlaces() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        
        do {
            let data = try await NetworkRequest<LocationsResponse>(url: requestURL).execute()
            self.places = data.locations
            self.requestError = nil
        } catch {
            self.requestError = error as? NetworkRequestError
        }
    }
}

