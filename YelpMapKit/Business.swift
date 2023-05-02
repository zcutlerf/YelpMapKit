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
    // TODO: Get other properties from our API as needed.
    
    // computed property that converts the coordinates returned from our API to a CLLocationCoordinate2D that is more useful to MapKit. because this is a computed property, it doesn't need to be present in our JSON response, or decoded.
    var clCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
    }
}

struct BusinessCoordinates: Codable {
    var latitude: Double
    var longitude: Double
}
