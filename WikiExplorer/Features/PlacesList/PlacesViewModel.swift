//
//  PlacesViewModel.swift
//  WikiExplorer
//
//  Created by Vikas Kharb on 16/02/2026.
//

import Combine
import Foundation

final class PlacesViewModel: ObservableObject {
    @Published private(set) var places: [Place] = []
    @Published private(set) var isLoading: Bool = false
    @Published var requestError: NetworkRequestError?
    
    private let repository: PlacesRepositoryProtocol
    private let appConnectService: AppConnectProtocol

    init(placesRepository: PlacesRepositoryProtocol = PlacesRepository(), appConnectService: AppConnectProtocol = AppConnectService()) {
        self.repository = placesRepository
        self.appConnectService = appConnectService
    }
    
    @MainActor
    func downloadPlaces() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        
        do {
            self.places = try await repository.downloadPlaces()
            self.requestError = nil
        } catch {
            self.requestError = error as? NetworkRequestError
        }
    }
    
    func connectToApp(latitude: Double, longitude: Double) async {
        do {
            try await appConnectService.open(latitude: latitude, longitude: longitude)
            // Another way of exclusively running a specific piece on the main actor rather than the entire method
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

