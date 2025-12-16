//
//  Home.swift
//  WeatherNews
//
//  Created by Macos on 21/10/2025.
//

import SwiftUI

struct WeatherDetailsView: View {
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
    WeatherDetailsView()
}


protocol WeatherPresentable {
    var timezone: Int { get }
    var dt: Int { get }
    var temp: Double { get }
    var description: String { get }
    var icon: String { get }
    var city: String { get }
    var country: String { get }
    var windSpeed: Double { get }
}
