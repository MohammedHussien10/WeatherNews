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
        VStack(alignment:.center,spacing: 16) {
            GeneralDetails()
            HourlyDetails()
            NextFiveDays()

        }.frame(maxWidth: .infinity,maxHeight: .infinity).background(
                LinearGradient(
                    colors: [Color.blue, Color.cyan],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ).ignoresSafeArea()
            )

    }
}


#Preview {
    HomeView()
}
