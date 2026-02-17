//
//  CustomLocationViewModel.swift
//  WikiExplorer
//
//  Created by Swati Sood on 17/02/2026.
//

import Foundation
import Combine

enum CoordinateValidationError: Error, LocalizedError {
    case invalidNumber
    case latitudeOutOfBounds
    case longitudeOutOfBounds
    
    var errorDescription: String? {
        switch self {
        case .invalidNumber:
            return "Please enter valid numbers for latitude and longitude."
            
        case .latitudeOutOfBounds:
            return "Latitude must be between -90.0 and 90.0."
            
        case .longitudeOutOfBounds:
            return "Longitude must be between -180.0 and 180.0."
        }
    }
}

final class CustomLocationViewModel: ObservableObject {
    @Published var requestError: Error?
    
    private let appConnectService: AppConnectProtocol
    
    init(appConnectService: AppConnectProtocol = AppConnectService()) {
        self.appConnectService = appConnectService
    }
    
    func validateCoordinatesAndConnectApp(lat: String, long: String) async {
        // Trim whitespace
        let latString = lat.trimmingCharacters(in: .whitespacesAndNewlines)
        let lonString = long.trimmingCharacters(in: .whitespacesAndNewlines)

        guard let lat = Double(latString), let lon = Double(lonString) else {
            requestError = CoordinateValidationError.invalidNumber
            return
        }

        guard (-90.0...90.0).contains(lat) else {
            requestError = CoordinateValidationError.latitudeOutOfBounds
            return
        }

        guard (-180.0...180.0).contains(lon) else {
            requestError = CoordinateValidationError.longitudeOutOfBounds
            return
        }
        
        requestError = nil
        await connectToApp(lat: lat, long: lon)
    }
    
    func connectToApp(lat: Double, long: Double) async {
        do {
            try await appConnectService.open(lat, long: long)
            requestError = nil
        } catch {
            requestError = error as? NetworkRequestError
        }
    }
    
}
