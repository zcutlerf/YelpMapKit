//
//  BusinessDetailView.swift
//  YelpMapKit
//
//  Created by Zoe Cutler on 5/1/23.
//

import SwiftUI

struct BusinessDetailView: View {
    var business: Business
    
    var body: some View {
        List {
            HStack {
                Text("name")
                    .fontWeight(.semibold)
                Spacer()
                Text(business.name)
            }
            
            HStack {
                Text("id")
                    .fontWeight(.semibold)
                Spacer()
                Text(business.id)
            }
        }
    }
}

struct BusinessDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BusinessDetailView(business: Business(id: "123", name: "Pizza Place", coordinates: BusinessCoordinates(latitude: 0.0, longitude: 0.0)))
    }
}
