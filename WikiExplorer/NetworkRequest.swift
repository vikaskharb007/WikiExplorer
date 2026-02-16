//
//  NetworkRequest.swift
//  WikiExplorer
//
//  Created by Vikas Kharb on 16/02/2026.
//

import Foundation

struct NetworkRequest<T: Decodable> {
    private let requestURL: String

    init(url: String) {
        self.requestURL = url
    }

    func execute() async throws -> T {
        guard let url = URL(string: requestURL) else {
            throw NetworkRequestError.genericError("Invalid URL")
        }

        let urlRequest = URLRequest(url: url)

        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let http = response as? HTTPURLResponse else {
                throw NetworkRequestError.unknown
            }
            
            guard (200..<300).contains(http.statusCode) else {
                throw NetworkRequestError.apiError("\(http.statusCode)")
            }
            
            return try decodeData(data: data)
        } catch {
            throw NetworkRequestError.apiError(error.localizedDescription)
        }
    }
    
    func decodeData(data: Data) throws -> T {
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkRequestError.jsonParseError
        }
    }
}
