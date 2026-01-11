//
//  RowOfFavoritesList.swift
//  WeatherNews
//
//  Created by Macos on 25/11/2025.
//

import SwiftUI

struct RowOfFavoritesList: View {
    @EnvironmentObject var viewModel: FavoritesViewModel
    @State private var showDeleteAlert = false
    @State private var favoriteToDelete: FavouritesModel?
    
    var body: some View {
        
        Group{
            
            if viewModel.favorites.isEmpty {
                ContentUnavailableView(
                    "no_favorites".localized,
                    systemImage: "heart",
                    description: 
                        Text("tap".localized)
                    + Text(Image(systemName: "heart"))
                    + Text( " to_add_favorite".localized)
                )
          
            } else {
                
                List {
                    ForEach(viewModel.favorites){ place in
                        NavigationLink {
                            let vm = HomeViewModel(getWeatherUseCase: viewModel.getWeatherUseCase)
                            
                            WeatherDetailsView(viewModel: vm, fromFavorites: true )
                                .task {
                                    await vm.fetchWeather(
                                        latitude: place.latitude,
                                        longitude: place.longitude
                                    )
                                }
                            
                        } label: {
                            VStack(alignment: .leading) {
                                Text(place.city)
                                    .font(.headline)
                                Text(place.country)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                    }.onDelete { indexSet in
                        if let index = indexSet.first {
                            favoriteToDelete = viewModel.favorites[index]
                            showDeleteAlert = true
                        }
                    }
                    
                }.alert("remove_favorite_title".localized, isPresented: $showDeleteAlert) {
                    Button("delete".localized, role: .destructive) {
                        if let fav = favoriteToDelete {
                            Task {
                                await viewModel.deleteFavorite(id: fav.id)
                                favoriteToDelete = nil
                            }
                        }
                    }
                    
                    Button("cancel".localized, role: .cancel) {
                        favoriteToDelete = nil
                    }
                } message: {
                    Text(
                           String(
                               format: "remove_favorite_message".localized,
                               favoriteToDelete?.city ?? "unknown".localized
                           )
                       )
                    
                }
                
            }
            
            
            
        }
    }
}
