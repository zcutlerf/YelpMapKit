//
//  ContentView.swift
//  YelpMapKit
//
//  Created by Zoe Cutler on 5/1/23.
//

import SwiftUI
import MapKit

struct ContentView: View {
    // holds the businesses queried during runtime
    @StateObject var businessVM = BusinessViewModel()
    
    // where the user is currently looking on the map, starting centered at Detroit (currently does not get user location)
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 42.34, longitude: -83.05), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    
    // what the user is searching for
    @State private var searchText = ""
    
    // if the http request fails, we'll show an alert with the error reason
    @State private var isShowingErrorAlert = false
    @State private var errorAlertText = ""
    
    // if we have tapped on a map annotation, we'll pass a Business instance here, and our sheet will show us the details
    @State private var detailBusiness: Business?
    
    var body: some View {
        Map(coordinateRegion: $mapRegion, annotationItems: businessVM.businesses) { business in
            // each Business will get an annotation that displays an icon and its name. (PLEASE make this look better - this is just an example and does not represent interface best practices.)
            MapAnnotation(coordinate: business.clCoordinate) {
                VStack {
                    Button {
                        // if we tap on a business, pass the business to this property so our sheet will show
                        detailBusiness = business
                    } label: {
                        Image(systemName: "building.2")
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                    
                    Text(business.name)
                        .font(.caption2)
                }
            }
        }
        
        .overlay(alignment: .top) {
            HStack {
                TextField("Search", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                
                Button {
                    searchForBusinesses()
                } label: {
                    Label("Search", systemImage: "arrow.forward.circle.fill")
                        .labelStyle(.iconOnly)
                }
            }
            .padding()
        }
        
        // the .sheet(item:) call allows us to only show the sheet if we've passed a business to the detailBusiness property.
        .sheet(item: $detailBusiness, content: { business in
            BusinessDetailView(business: business)
        })
        
        // if the http request fails, we'll show an alert with the error reason
        .alert("Error Searching", isPresented: $isShowingErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorAlertText)
        }
        
    }
    
    // tell our ViewModel to perform the HTTP request, and handle an error if it occurs.
    func searchForBusinesses() {
        Task {
            do {
                try await businessVM.businesses(searchingFor: searchText, at: mapRegion.center)
            } catch {
                errorAlertText = error.localizedDescription
                isShowingErrorAlert = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
