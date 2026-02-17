//
//  MockPlacesRepository.swift
//  WikiExplorer
//
//  Created by Vikas Kharb on 17/02/2026.
//


import Foundation
import Testing
@testable import WikiExplorer


@Suite("PlacesViewModel")
struct PlacesViewModelTests {
    @Test("downloadPlaces success updates places and clears error")
    @MainActor
    func downloadPlacesSuccess() async throws {
        let mockRepo = MockPlacesRepository()
        let samplePlaces: [Place] = [
            Place(id: UUID(), title: "One", latitude: 52.35, longitude: 4.83),
            Place(id: UUID(), title: "Two", latitude: 19.08, longitude: 72.834)
        ]
        mockRepo.result = .success(samplePlaces)
        let mockConnect = MockAppConnectService()
        let sut = PlacesViewModel(placesRepository: mockRepo, appConnectService: mockConnect)

        await sut.downloadPlaces()

        #expect(sut.isLoading == false)
        #expect(sut.places.count == 2)
        #expect(sut.requestError == nil)
    }

    @Test("downloadPlaces failure sets requestError and keeps places unchanged")
    @MainActor
    func downloadPlacesFailure() async throws {
        let mockRepo = MockPlacesRepository()
        mockRepo.result = .failure(NetworkRequestError.jsonParseError)
        let mockConnect = MockAppConnectService()
        let sut = PlacesViewModel(placesRepository: mockRepo, appConnectService: mockConnect)

        await sut.downloadPlaces()

        #expect(sut.isLoading == false)
        #expect(sut.places.isEmpty)
        #expect(sut.requestError == NetworkRequestError.jsonParseError)
    }

    @Test("connectToApp success calls service and clears error")
    @MainActor
    func connectToAppSuccess() async throws {
        let mockRepo = MockPlacesRepository()
        let mockConnect = MockAppConnectService()
        mockConnect.result = .success(())
        let sut = PlacesViewModel(placesRepository: mockRepo, appConnectService: mockConnect)

        await sut.connectToApp(lat: 12.34, long: 56.78)

        let called = try #require(mockConnect.openCalled)
        #expect(called.lat == 12.34 && called.long == 56.78)
        #expect(sut.requestError == nil)
    }

    @Test("connectToApp failure sets requestError")
    @MainActor
    func connectToAppFailure() async throws {
        let mockRepo = MockPlacesRepository()
        let mockConnect = MockAppConnectService()
        mockConnect.result = .failure(NetworkRequestError.genericError("invalid URL"))
        let sut = PlacesViewModel(placesRepository: mockRepo, appConnectService: mockConnect)

        await sut.connectToApp(lat: 0, long: 0)

        #expect(sut.requestError == NetworkRequestError.genericError("invalid URL"))
    }
}
