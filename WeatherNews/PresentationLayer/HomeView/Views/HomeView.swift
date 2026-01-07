//
//  Home.swift
//  WeatherNews
//
//  Created by Macos on 21/10/2025.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    var body: some View {
        NavigationStack{
        WeatherDetailsView(viewModel: viewModel, fromFavorites: false)
            .task {
                await viewModel.loadCachedOrFetch(
                    latitude: viewModel.lat,
                    longitude: viewModel.long
                )
            }
        
    }.toolbarBackground(Color.blue, for:.navigationBar)
    .toolbarBackground(Color.blue, for: .tabBar)
    .toolbarColorScheme(.dark, for: .navigationBar)
    .navigationBarTitleDisplayMode(.inline)



}
}


#Preview {
    HomeView()
}


