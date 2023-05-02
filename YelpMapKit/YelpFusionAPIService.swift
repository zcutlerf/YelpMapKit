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
    // query businesses from the Yelp Fusion API, returning a list of businesses or throwing an error
    func businesses(searchingFor term: String, at location: CLLocationCoordinate2D) async throws -> [Business] {
        // outline the components of the URL. this makes it cleaner and easier to specify query items.
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.yelp.com"
        urlComponents.path = "/v3/businesses/search"
        
        // REQUIRED QUERY PARAMS: latitude and longitude
        let latitudeQueryItem = URLQueryItem(name: "latitude", value: location.latitude.description)
        let longitudeQueryItem = URLQueryItem(name: "longitude", value: location.longitude.description)
        
        // Optional query params: term (i.e.: what the user searches for)
        let termQueryItem = URLQueryItem(name: "term", value: term)
        
        // add the query params to our URL (this way we don't have to do string interpolation like ?term=\(term), and also will encode special characters in case our users type those in)
        urlComponents.queryItems = [termQueryItem, latitudeQueryItem, longitudeQueryItem]
        
        // construct the URL from components
        guard let url = urlComponents.url else { throw URLError(.badURL) }
        
        // make a URL request from our URL
        var request = URLRequest(url: url)
        // specify the authorization type required by the Yelp Fusion API
        request.setValue("Bearer \(yelpAPIKey)", forHTTPHeaderField: "Authorization")
        
        // get the data from the request
        let (data, _) = try await URLSession(configuration: .default).data(for: request)
        
        // decode the response
        let response = try JSONDecoder().decode(YelpFusionAPIResponse.self, from: data)
        
        // return just the businesses object from the response
        return response.businesses
    }
}
