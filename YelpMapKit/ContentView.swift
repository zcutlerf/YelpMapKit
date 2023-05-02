//
//  ContentView.swift
//  YelpMapKit
//
//  Created by Zoe Cutler on 5/1/23.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject var businessVM = BusinessViewModel()
    
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 42.34, longitude: -83.05), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    
    @State private var searchText = ""
    
    @State private var isShowingErrorAlert = false
    @State private var errorAlertText = ""
    
    @State private var detailBusiness: Business?
    
    var body: some View {
        Map(coordinateRegion: $mapRegion, annotationItems: businessVM.businesses) { business in
            MapAnnotation(coordinate: business.clCoordinate) {
                VStack {
                    Button {
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
        .sheet(item: $detailBusiness, content: { business in
            BusinessDetailView(business: business)
        })
        .alert("Error Searching", isPresented: $isShowingErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorAlertText)
        }
        
    }
    
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
