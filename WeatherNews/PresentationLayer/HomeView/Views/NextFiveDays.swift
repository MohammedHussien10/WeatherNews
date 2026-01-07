//
//  NextFiveDays.swift
//  WeatherNews
//
//  Created by Macos on 20/11/2025.
//

import SwiftUI
import Kingfisher

struct NextFiveDays: View {
    let forecast: [ForecastItem]?
    let timezone: Int
    let temperatureUnit: TemperatureUnit
    private let helper: HelperWeatherDetails = HelperWeatherDetails()
    
    var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                Text("Next 5 Days")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                
              
                    
                    if let forecastList = forecast {
                    ForEach(helper.getNextFiveDays(list: forecastList), id: \.dt) { item in
                        HStack(spacing: 16) {
                            Text(helper.formattedDate(from: item.dt,
                                                         timezone: timezone))
                            .font(.headline)
                            .foregroundColor(.white)
                            
                            Spacer()
                        
                            if let icon = item.weather.first?.icon {
                                KFImage(icon.weatherIconURL)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                            }

                            Text(
                                String(format: "%.0f %@", item.main.temp, temperatureUnit.displayShort)
                            )
                        }
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                }
            
            } .padding(.bottom, 10)
        }
    }
    





//#Preview {
//    NextFiveDays()
//}
