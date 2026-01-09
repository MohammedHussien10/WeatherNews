//
//  Hourly Details.swift
//  WeatherNews
//
//  Created by Macos on 20/11/2025.
//

import SwiftUI
import Kingfisher

struct HourlyDetails: View {
    let forecast: [ForecastItem]?
    let timezone: Int
    let temperatureUnit: TemperatureUnit
    private let helper: HelperWeatherDetails = HelperWeatherDetails()
    let rows = [
        GridItem(.fixed(150))
    ]

    var body: some View {
        VStack(alignment: .leading,spacing: 12){
            Text("Hourly Details")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color.init(hex: "#5b5b5b"))
                .padding(.horizontal)

            ScrollView(.horizontal,showsIndicators: false){
                LazyHGrid(rows:rows,spacing: 16){
                    if let forecast = forecast{
                        ForEach(forecast.prefix(20),id:\.dt){ item in
                            VStack(spacing:8){
                                Text(helper.formattedTime(from: item.dt, timezone: timezone)).font(.caption)
                                
                                if let icon = item.weather.first?.icon{
                                    KFImage(icon.weatherIconURL).resizable()
                                        .scaledToFit().frame(width: 50,height:50)
                                }
                                
                                Text(String(format: "%.0f %@", item.main.temp, temperatureUnit.displayShort))
                                    .font(.headline)
                                
                            }.frame(width: 120, height: 150).background(Color.blue.opacity(0.2)).cornerRadius(12)
                        }
                    }
                }.padding(.horizontal)
            }
        }
    }
}

//#Preview {
//    HourlyDetails()
//}
