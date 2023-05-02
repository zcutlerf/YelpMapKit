//
//  BusinessViewModel.swift
//  YelpMapKit
//
//  Created by Zoe Cutler on 5/1/23.
//

import SwiftUI
import CoreLocation

@MainActor class BusinessViewModel: ObservableObject {
    // the list of businesses returned by the Yelp Fusion API
    @Published var businesses: [Business] = []
    
    // query our service to search for businesses, and pass the error up to the view so that the user will be aware if it fails
    func businesses(searchingFor term: String, at location: CLLocationCoordinate2D) async throws {
        self.businesses = try await YelpFusionAPIService().businesses(searchingFor: term, at: location)
    }
}
