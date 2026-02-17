//
//  AppConnectService.swift
//  WikiExplorer
//
//  Created by Vikas Kharb on 17/02/2026.
//


import UIKit

struct AppConnectService: AppConnectProtocol {
    private let application: UIApplication
    
    public init(application: UIApplication) {
        self.application = application
    }
    
     func open(latitude: Double, longitude: Double) async throws {
         let wikiURL = try await generateURL(latitude: latitude, longitude: longitude)
        
         Task { @MainActor in
             await application.open(wikiURL)
         }
    }
    
    func generateURL(latitude: Double, longitude: Double) async throws -> URL {
        guard let url = URL(string: "wikipedia://places?coordinates=\(latitude),\(longitude)") else {
            throw NetworkRequestError.genericError("Invalid url")
        }
        
        return url
    }
}

extension AppConnectService {
    init() {
        self.application = UIApplication.shared
    }
}
