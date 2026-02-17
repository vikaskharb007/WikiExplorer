//
//  CustomLocationViewModel.swift
//  WikiExplorer
//
//  Created by Vikas Kharb on 17/02/2026.
//

import Foundation
import Combine

final class CustomLocationViewModel: ObservableObject {
    @Published var requestError: Error?
    private let latitudeRange = -90.0...90.0
    private let longitudeRange = -180.0...180.0
    
    private let appConnectService: AppConnectProtocol
    
    init(appConnectService: AppConnectProtocol = AppConnectService()) {
        self.appConnectService = appConnectService
    }
    
    @MainActor
    func connectIfValid(lat: String, long: String) async {
        // Trim whitespace
        let latString = lat.trimmingCharacters(in: .whitespacesAndNewlines)
        let lonString = long.trimmingCharacters(in: .whitespacesAndNewlines)
    
        guard let latitude = Double(latString.replacingOccurrences(of: ",", with: ".")),
              let longitude = Double(lonString.replacingOccurrences(of: ",", with: "."))
        else {
            requestError = CoordinateValidationError.invalidNumber
            return
        }

        guard latitudeRange.contains(latitude) else {
            requestError = CoordinateValidationError.latitudeOutOfBounds
            return
        }

        guard longitudeRange.contains(longitude) else {
            requestError = CoordinateValidationError.longitudeOutOfBounds
            return
        }
        
        requestError = nil
        await connectToApp(latitude: latitude, longitude: longitude)
    }
    
    func connectToApp(latitude: Double, longitude: Double) async {
        do {
            try await appConnectService.open(latitude: latitude, longitude: longitude)
            await MainActor.run {
                requestError = nil
            }
        } catch {
            await MainActor.run {
                guard let networkRequestError = error as? NetworkRequestError else {
                    requestError = NetworkRequestError.genericError(error.localizedDescription)
                    return
                }
                requestError = networkRequestError
            }
        }
    }
    
}
