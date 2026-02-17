//
//  PlacesRepository.swift
//  WikiExplorer
//
//  Created by Vikas Kharb on 16/02/2026.
//

struct PlacesRepository: PlacesRepositoryProtocol {
    private let requestURL = "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json"
    private let client: NetworkClient
    
    init(client: NetworkClient = DefaultNetworkClient()) {
        self.client = client
    }
    
    func downloadPlaces() async throws -> [Place] {
        let response: LocationsResponse = try await client.get(requestURL)
        return response.locations
    }
}
