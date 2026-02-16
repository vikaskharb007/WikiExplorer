//
//  NetworkRequestError.swift
//  WikiExplorer
//
//  Created by Vikas Kharb on 16/02/2026.
//

import Foundation

enum NetworkRequestError: Error {
    case jsonParseError
    case apiError(String)
    case genericError(String)
    case unknown
    
    var title: String {
        switch self {
        case .jsonParseError:
           return "Bad Response"
            
        case .apiError(_), .genericError(_):
            return "Request Failed"
            
        case .unknown:
            return "Something went wrong"
        }
    }
    
    var message: String {
        switch self {
        
        case .jsonParseError:
            return "Something went wrong with the response. Please try again later"
            
        case .apiError(let description), .genericError(let description) :
            return "Request Failed - \(description)"
           
        case .unknown:
            return "An unknown error occurred. Please try again later."
        }
    }
}
