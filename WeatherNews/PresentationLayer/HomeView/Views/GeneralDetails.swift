//
//  GeneralDetails.swift
//  WeatherNews
//
//  Created by Macos on 17/11/2025.
//

import SwiftUI
import Kingfisher
struct GeneralDetails: View {
    let currentWeather: WeatherResponse?
    let windSpeedConverter: Double?
    let temperatureUnit: TemperatureUnit
    let windSpeedUnit: WindSpeedUnit
    let fallbackCityName: String?
    let fallbackCountryName: String?
    private let helper: HelperWeatherDetails = HelperWeatherDetails()
    var body: some View {
        VStack(alignment:.center){
            HStack{
                if let weather = currentWeather{
                    Text(weather.weather.first?.description ?? "")
                    weatherIcon(weather.weather.first?.icon.weatherIconURL)
                    VStack{
                        Text("Today").font(.headline)
                        Text(helper.formattedDate(from: weather.dt, timezone: weather.timezone)  )
                        Text(helper.formattedTime(from: weather.dt, timezone: weather.timezone)  )
                        Text(String(format: "%.1f %@", windSpeedConverter ?? 0.0, windSpeedUnit.shortName))
                        
                    }
                    
                }
                
            }
            
            VStack(spacing: 16) {
                if let weather = currentWeather {
                    Text(
                        String(format: "%.0f %@", weather.main.temp, temperatureUnit.displayShort)
                    )
                    .font(.largeTitle)

                    let country = (weather.sys.country?.isEmpty == false) ? weather.sys.country?.fullCountryName : fallbackCountryName
                    let city = (weather.name?.isEmpty == false) ? weather.name: fallbackCityName

                    let locationName: String = {
                        if let city, let country {
                            return "\(city), \(country)"
                        }
                        if let city {
                            return city
                        }
                        if let country {
                            return country
                        }
                        return "Unknown"
                    }()

                    Text(locationName)
                        .font(.title3)
                }
            }
   
        }
    }
}

//#Preview {
//    GeneralDetails()
//}



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
