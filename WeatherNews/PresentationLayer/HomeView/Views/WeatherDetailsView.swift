//
//  WeatherDetailsView.swift
//  WeatherNews
//
//  Created by Macos on 11/12/2025.
//

import SwiftUI

struct HomeDetailsView: View {
    @EnvironmentObject var viewModel : HomeViewModel
    
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
    HomeDetailsView()
}
