//
//  BusinessViewModel.swift
//  YelpMapKit
//
//  Created by Zoe Cutler on 5/1/23.
//

import SwiftUI
import CoreLocation

@MainActor class BusinessViewModel: ObservableObject {
    @Published var businesses: [Business] = []
    
    func businesses(searchingFor term: String, at location: CLLocationCoordinate2D) async throws {
        self.businesses = try await YelpFusionAPIService().businesses(searchingFor: term, at: location)
    }
}
