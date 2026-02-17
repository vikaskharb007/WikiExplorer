//
//  PlacesViewRow.swift
//  WikiExplorer
//
//  Created by Vikas Kharb on 17/02/2026.
//

import SwiftUI

struct PlacesViewRow: View {
    let place: Place
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(place.title)
                .font(.headline)
                .padding(.bottom)
            
            Text(place.displayCoordinates)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .contentShape(Rectangle())
    }
    
}
