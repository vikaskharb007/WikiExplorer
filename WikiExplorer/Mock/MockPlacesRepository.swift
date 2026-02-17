//
//  MockPlacesRepository.swift
//  WikiExplorer
//
//  Created by Vikas Kharb on 17/02/2026.
//


final class MockPlacesRepository: PlacesRepositoryProtocol {
    var result: Result<[Place], Error> = .success([])
    func downloadPlaces() async throws -> [Place] {
        switch result {
        case .success(let places):
            return places
        case .failure(let error):
            throw error
        }
    }
}
