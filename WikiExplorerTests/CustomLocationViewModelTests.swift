//
//  MockAppConnectServiceForCustom.swift
//  WikiExplorer
//
//  Created by Vikas Kharb on 17/02/2026.
//


import Foundation
import Testing
@testable import WikiExplorer

@Suite("CustomLocationViewModel")
struct CustomLocationViewModelTests {
    @Test("invalid numbers set CoordinateValidationError.invalidNumber")
    @MainActor
    func invalidNumbers() async throws {
        let mock = MockAppConnectService()
        let sut = CustomLocationViewModel(appConnectService: mock)

        await sut.connectIfValid(lat: "abc", long: "123")
        #expect((sut.requestError as? CoordinateValidationError) == .invalidNumber)

        await sut.connectIfValid(lat: "12.3", long: "xyz")
        #expect((sut.requestError as? CoordinateValidationError) == .invalidNumber)
        #expect((sut.requestError as? CoordinateValidationError)?.errorDescription == "Please enter valid numbers for latitude and longitude.")
    }

    @Test("latitude out of bounds sets error")
    @MainActor
    func latitudeOutOfBounds() async throws {
        let mock = MockAppConnectService()
        let sut = CustomLocationViewModel(appConnectService: mock)

        await sut.connectIfValid(lat: "-90.1", long: "0")
        #expect((sut.requestError as? CoordinateValidationError) == .latitudeOutOfBounds)

        await sut.connectIfValid(lat: "90.5", long: "0")
        #expect((sut.requestError as? CoordinateValidationError) == .latitudeOutOfBounds)
        #expect((sut.requestError as? CoordinateValidationError)?.errorDescription == "Latitude must be between -90.0 and 90.0.")
        
    }

    @Test("longitude out of bounds sets error")
    @MainActor
    func longitudeOutOfBounds() async throws {
        let mock = MockAppConnectService()
        let sut = CustomLocationViewModel(appConnectService: mock)

        await sut.connectIfValid(lat: "0", long: "-180.5")
        #expect((sut.requestError as? CoordinateValidationError) == .longitudeOutOfBounds)

        await sut.connectIfValid(lat: "0", long: "180.1")
        #expect((sut.requestError as? CoordinateValidationError) == .longitudeOutOfBounds)
        #expect((sut.requestError as? CoordinateValidationError)?.errorDescription == "Longitude must be between -180.0 and 180.0.")
    }

    @Test("trims whitespace and calls connect on success")
    @MainActor
    func trimsWhitespaceAndConnects() async throws {
        let mock = MockAppConnectService()
        let sut = CustomLocationViewModel(appConnectService: mock)

        await sut.connectIfValid(lat: "  12.34  ", long: "  -56.78\n")

        let called = try #require(mock.openCalled)
        #expect(called.lat == 12.34)
        #expect(called.long == -56.78)
        #expect(sut.requestError == nil)
    }

    @Test("connectToApp success clears error")
    @MainActor
    func connectSuccess() async throws {
        let mock = MockAppConnectService()
        mock.result = .success(())
        let sut = CustomLocationViewModel(appConnectService: mock)
        sut.requestError = CoordinateValidationError.invalidNumber

        await sut.connectToApp(latitude: 1, longitude: 2)

        #expect(sut.requestError == nil)
    }

    @Test("connectToApp failure sets NetworkRequestError")
    @MainActor
    func connectFailure() async throws {
        let mock = MockAppConnectService()
        mock.result = .failure(NetworkRequestError.genericError("Invalid URL"))
        let sut = CustomLocationViewModel(appConnectService: mock)

        await sut.connectToApp(latitude: 0, longitude: 0)

        #expect((sut.requestError as? NetworkRequestError) == NetworkRequestError.genericError("Invalid URL"))
    }
}
