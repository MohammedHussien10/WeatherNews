//
//  GeneralDetails.swift
//  WeatherNews
//
//  Created by Macos on 17/11/2025.
//

import SwiftUI
import Kingfisher
struct GeneralDetails: View {
    @EnvironmentObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack(alignment:.center){
            HStack{
                if let weather = viewModel.currentWeather{
                    Text(weather.weather.first?.description ?? "")
                    weatherIcon(weather.weather.first?.icon.weatherIconURL)
                    VStack{
                        Text("Today").font(.headline)
                        Text(viewModel.formattedDate(from: weather.dt, timezone: weather.timezone)  )
                        Text(viewModel.formattedTime(from: weather.dt, timezone: weather.timezone)  )
                        Text(String(format: "%.1f %@", viewModel.windSpeedConverter ?? 0.0, viewModel.windSpeedUnit.shortName))
                        
                    }
                    
                }
                
            }
            
            VStack(spacing: 16){
                if let weather = viewModel.currentWeather{
                    Text(String(format: "%.0f %@", weather.main.temp, viewModel.temperatureUnit.displayShort))
                        .font(.largeTitle)
                    Text("\(weather.sys.country.fullCountryName),\(weather.name)").font(.title3)
                }
            }
            
     
        }
    }
}

#Preview {
    GeneralDetails()
}

// for Weather icon
extension String {
    var weatherIconURL: URL? {
        return URL(string: "https://openweathermap.org/img/wn/\(self)@2x.png")
    }
}


extension View {
    @MainActor func weatherIcon(_ url: URL?, size: CGFloat = 80) -> some View {
        KFImage(url)
            .placeholder {
                ProgressView()
            }
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
    }
}

// for make name of Country Clear

extension String {
    var fullCountryName: String {
        return Locale.current.localizedString(forRegionCode: self) ?? self
    }
}

