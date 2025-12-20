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
                NavigationLink {
                    let vm = HomeViewModel(getWeatherUseCase: viewModel.getWeatherUseCase)

                    WeatherDetailsView(viewModel: vm)
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
