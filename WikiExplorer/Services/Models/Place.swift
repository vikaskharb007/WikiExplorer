//
//  Place.swift
//  WikiExplorer
//
//  Created by Vikas Kharb on 16/02/2026.
//

import Foundation

struct Place: Identifiable, Decodable, Sendable {
    let id: UUID
    let title: String
    let latitude: Double
    let longitude: Double

    enum CodingKeys: String, CodingKey {
        case name
        case lat
        case long
    }

    init(id: UUID, title: String, latitude: Double, longitude: Double) {
        self.id = id
        self.title = title
        self.latitude = latitude
        self.longitude = longitude
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let title = try container.decodeIfPresent(String.self, forKey: .name) ?? "Unknown"
        let latitude = try container.decode(Double.self, forKey: .lat)
        let longitude = try container.decode(Double.self, forKey: .long)
        self.init(id: UUID(), title: title, latitude: latitude, longitude: longitude)
    }
}

extension Place {
    var displayCoordinates: String {
        "Latitude: \(latitude), Longitude: \(longitude)"
    }
}
