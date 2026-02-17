//
//  DefaultNetworkClient.swift
//  WikiExplorer
//
//  Created by Vikas Kharb on 17/02/2026.
//


struct DefaultNetworkClient: NetworkClient {
    func get<Response: Decodable>(_ urlString: String) async throws -> Response {
        try await NetworkRequest<Response>(url: urlString).execute()
    }
}
