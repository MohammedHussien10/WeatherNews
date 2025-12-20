//
//  Favorites.swift
//  WeatherNews
//
//  Created by Macos on 21/10/2025.
//

import SwiftUI
struct Favorites: View {
    @EnvironmentObject var viewModel: FavoritesViewModel
    @State private var showMap = false
    var body: some View {
        NavigationStack {
            ZStack{
                RowOfFavoritesList().environmentObject(viewModel)
                
                FAB{
                    showMap = true
                }
            }.navigationTitle("Favorites")
                .task {
                    await viewModel.loadFavorites()
                }
                .navigationDestination(isPresented: $showMap) {
                    MapView(mode: .favorites) { ـ in
                        
                    }.environmentObject(viewModel)
                    
                }
        }
    }
}
#Preview {
    Favorites()
}


