//
//  MapView.swift
//  GuessTheFlag
//
//  Created by Alexandre Moreau-Lemay on 28/07/2021.
//

import SwiftUI
import MapKit

struct MapView: View {
    var country: Country
    
    var body: some View {
        Map(coordinateRegion: .constant(country.region), interactionModes: MapInteractionModes())
    }
}

struct MapView_Preview: PreviewProvider {
    static var countries = ModelData().countries
    
    static var previews: some View {
        let id: Int = 0
        
        MapView(country: countries[id])
    }
}
