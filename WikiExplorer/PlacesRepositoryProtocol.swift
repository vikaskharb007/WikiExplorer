//
//  PlacesRepositoryProtocol.swift
//  WikiExplorer
//
//  Created by Vikas Kharb on 16/02/2026.
//

protocol PlacesRepositoryProtocol {
    func downloadPlaces() async throws -> [Place]
}
