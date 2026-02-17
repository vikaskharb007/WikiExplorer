//
//  CoordinateValidationError.swift
//  WikiExplorer
//
//  Created by Vikas Kharb on 17/02/2026.
//

import Foundation

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
