//
//  Favorites.swift
//  WeatherNews
//
//  Created by Macos on 21/10/2025.
//

import SwiftUI
struct Favorites: View {
    @State private var showMap = false
    var body: some View {
        NavigationStack {
            VStack{
              
                
                FAB{
                    showMap = true
                }
            }
        } .navigationDestination(isPresented: $showMap) {
            MapView()
        }
    }
}

#Preview {
    Favorites()
}


