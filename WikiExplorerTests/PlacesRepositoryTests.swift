//
//  PlacesRepositoryTests.swift
//  WikiExplorer
//
//  Created by Vikas Kharb on 17/02/2026.
//

import Foundation
import Testing
@testable import WikiExplorer

@MainActor
@Suite("PlacesRepository")
struct PlacesRepositoryTests {
    @Test("success returns places")
    func success() async throws {
        let sample = LocationsResponse(locations: [Place(id: UUID(), title: "Paris", latitude: 23.54, longitude: 45.65)])
        let mock = MockNetworkClient()
        mock.result = .success(sample)

        let sut = PlacesRepository(client: mock)
        let places = try await sut.downloadPlaces()

        #expect(places.count == 1)
    }

    @Test("parsing error propagates")
    func serverError() async throws {
        let mock = MockNetworkClient()
        mock.result = .failure(NetworkRequestError.jsonParseError)

        let sut = PlacesRepository(client: mock)
        do {
            _ = try await sut.downloadPlaces()
            Issue.record("Expected NetworkRequestError.jsonParseError")
        } catch let error as NetworkRequestError {
            #expect(error == .jsonParseError)
        }
    }
}
