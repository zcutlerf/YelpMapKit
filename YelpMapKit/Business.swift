//
//  Business.swift
//  YelpMapKit
//
//  Created by Zoe Cutler on 5/1/23.
//

import Foundation
import CoreLocation

struct Business: Codable, Identifiable {
    var id: String
    var name: String
    var coordinates: BusinessCoordinates
    
    var clCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
    }
}

struct BusinessCoordinates: Codable {
    var latitude: Double
    var longitude: Double
}
