//
//  Countries.swift
//  GuessTheFlag
//
//  Created by Alexandre Moreau-Lemay on 27/07/2021.
//

import Foundation
import MapKit

struct Country: Codable, Hashable, Identifiable {
    // Loaded from JSON
    var id: Int
    var name: String
    var flag: String
    var capital: String
    var exclusions: [String]
    var altname: [String]
    var coordinates: Coordinates
    private var delta: Double
    
    // Computed
    private var deltaSpan: CLLocationDegrees {
        if delta == 0 {
            return 15
        } else {
            return delta
        }
    }
    
    var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: self.locationCoordinate,
            span: MKCoordinateSpan(latitudeDelta: self.deltaSpan, longitudeDelta: self.deltaSpan)
        )
    }
    
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude)
    }
    
    struct Coordinates: Hashable, Codable {
        var latitude: Double
        var longitude: Double
    }
}
