//
//  NextFiveDays.swift
//  WeatherNews
//
//  Created by Macos on 20/11/2025.
//

import SwiftUI
import Kingfisher

struct NextFiveDays: View {
    @EnvironmentObject var viewModel: HomeViewModel
    
    var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                Text("Next 5 Days")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                
                ScrollView(.vertical,showsIndicators: false){
                    
                if let forecastList = viewModel.forecast?.list {
                    ForEach(viewModel.getNextFiveDays(list: forecastList), id: \.dt) { forecast in
                        HStack(spacing: 16) {
                            Text(viewModel.formattedDate(from: forecast.dt,
                                                         timezone: viewModel.forecast?.city.timezone ?? 0))
                            .font(.headline)
                            .foregroundColor(.white)
                            
                            Spacer()
                        
                            if let icon = forecast.weather.first?.icon {
                                KFImage(icon.weatherIconURL)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                            }
                            
                            Text(String(format: "%.0f %@", forecast.main.temp,
                                        viewModel.temperatureUnit.displayShort))
                            .font(.headline)
                            .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                }
            }
            } .padding(.bottom, 10)
        }
    }
    





#Preview {
    NextFiveDays()
}
