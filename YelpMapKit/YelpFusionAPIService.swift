//
//  YelpFusionAPIService.swift
//  YelpMapKit
//
//  Created by Zoe Cutler on 5/1/23.
//

import Foundation
import CoreLocation

struct YelpFusionAPIResponse: Codable {
    var businesses: [Business]
}

actor YelpFusionAPIService {
    func businesses(searchingFor term: String, at location: CLLocationCoordinate2D) async throws -> [Business] {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.yelp.com"
        urlComponents.path = "/v3/businesses/search"
        
        //REQUIRED QUERY PARAMS: latitude and longitude
        let latitudeQueryItem = URLQueryItem(name: "latitude", value: location.latitude.description)
        let longitudeQueryItem = URLQueryItem(name: "longitude", value: location.longitude.description)
        
        //Optional query params: term (i.e.: what the user searches for)
        let termQueryItem = URLQueryItem(name: "term", value: term)
        
        urlComponents.queryItems = [termQueryItem, latitudeQueryItem, longitudeQueryItem]
        
        guard let url = urlComponents.url else { throw URLError(.badURL) }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(yelpAPIKey)", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession(configuration: .default).data(for: request)
        
        let response = try JSONDecoder().decode(YelpFusionAPIResponse.self, from: data)
        
        return response.businesses
    }
}
