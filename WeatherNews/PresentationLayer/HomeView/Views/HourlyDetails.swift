//
//  Hourly Details.swift
//  WeatherNews
//
//  Created by Macos on 20/11/2025.
//

import SwiftUI
import Kingfisher

struct HourlyDetails: View {
    @EnvironmentObject var viewModel: HomeViewModel
    let rows = [
        GridItem(.fixed(150))
    ]

    var body: some View {
        VStack(alignment: .leading,spacing: 12){
            Text("Hourly Details")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal)

            ScrollView(.horizontal,showsIndicators: false){
                LazyHGrid(rows:rows,spacing: 16){
                    if let forecast = viewModel.forecast?.list{
                        ForEach(forecast.prefix(20),id:\.dt){ forecast in
                            VStack(spacing:8){
                                Text(viewModel.formattedTime(from: forecast.dt, timezone: viewModel.forecast?.city.timezone ?? 0)).font(.caption)
                                
                                if let icon = forecast.weather.first?.icon{
                                    KFImage(icon.weatherIconURL).resizable()
                                        .scaledToFit().frame(width: 50,height:50)
                                }
                                
                                Text(String(format: "%.0f %@", forecast.main.temp, viewModel.temperatureUnit.displayShort))
                                    .font(.headline)
                                
                            }.frame(width: 120, height: 150).background(Color.blue.opacity(0.2)).cornerRadius(12)
                        }
                    }
                }.padding(.horizontal)
            }
        }
    }
}

#Preview {
    HourlyDetails()
}
