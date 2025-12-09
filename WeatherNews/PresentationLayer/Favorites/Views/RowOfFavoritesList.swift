//
//  RowOfFavoritesList.swift
//  WeatherNews
//
//  Created by Macos on 25/11/2025.
//

import SwiftUI

struct RowOfFavoritesList: View {
    @EnvironmentObject var viewModel: FavoritesViewModel
    var body: some View {
        List {
            ForEach(viewModel.favorites){ place in
                NavigationLink(destination:WeatherDetailsScreen(place:place) ){
                    VStack(alignment: .leading) {
                        Text(place.city)
                            .font(.headline)
                        Text(place.country)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }.onDelete{ indexSet in
                if let index = indexSet.first{
                    let id = viewModel.favorites[index].id
                    Task{
                        await viewModel.deleteFavorite(id: id)
                    }
                }
            }
        }
    }
    
    //#Preview {
    //    RowOfFavoritesList()
    //}
    
    
   
}
struct WeatherDetailsScreen: View {
    let place: FavouritesModel
    
    var body: some View {
        VStack(spacing: 16) {
            Text(place.city)
                .font(.largeTitle)
            Text(place.country)
            
            Text("Lat: \(place.latitude)")
            Text("Lon: \(place.longitude)")
            
            Spacer()
        }
        .padding()
        .navigationTitle("Weather Details")
    }
}
