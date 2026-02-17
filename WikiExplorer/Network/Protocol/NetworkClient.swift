//
//  NetworkClient.swift
//  WikiExplorer
//
//  Created by Vikas Kharb on 17/02/2026.
//


protocol NetworkClient {
    func get<Response: Decodable>(_ urlString: String) async throws -> Response
}
