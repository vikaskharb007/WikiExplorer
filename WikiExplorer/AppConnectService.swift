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
    
     func open(_ lat: Double, long: Double) async throws {
        let wikiURL = try await generateURL(lat, long: long)
        
         Task { @MainActor in
             await application.open(wikiURL)
         }
    }
    
    func generateURL(_ lat: Double, long: Double) async throws -> URL {
        guard let url = URL(string: "wikipedia://places?coordinates=\(lat),\(long)") else {
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
