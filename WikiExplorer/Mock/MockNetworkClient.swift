//
//  MockNetworkClient.swift
//  WikiExplorer
//
//  Created by Vikas Kharb on 17/02/2026.
//

 final class MockNetworkClient: NetworkClient {
    var result: Result<Any, Error>?

    func get<Response>(_ urlString: String) async throws -> Response where Response : Decodable {
        guard let result = result else {
            throw NetworkRequestError.unknown
        }
        switch result {
        case .success(let any):
            guard let response = any as? Response else {
                throw NetworkRequestError.jsonParseError
            }
            return response
        case .failure(let error):
            throw error
        }
    }
}
