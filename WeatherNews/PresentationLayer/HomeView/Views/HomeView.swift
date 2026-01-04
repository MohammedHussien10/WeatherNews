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
        WeatherDetailsView(viewModel: viewModel)
            .task {
                await viewModel.loadCachedOrFetch(
                    latitude: viewModel.lat,
                    longitude: viewModel.long
                )
            }

    }
}


#Preview {
    HomeView()
}


