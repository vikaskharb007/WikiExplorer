//
//  PlacesRepository.swift
//  WikiExplorer
//
//  Created by Vikas Kharb on 16/02/2026.
//

private struct LocationsResponse: Decodable {
    let locations: [Place]
}

class PlacesRepository: PlacesRepositoryProtocol {
    private let requestURL = "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json"
    
    func downloadPlaces() async throws -> [Place] {
        let data = try await NetworkRequest<LocationsResponse>(url: requestURL).execute()
        return data.locations
    }
}
