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
    let forecast: ForecastResponse?
    let windSpeedConverter: Double?
    let temperatureUnit: TemperatureUnit
    let windSpeedUnit: WindSpeedUnit
    let fallbackCityName: String?
    let fallbackCountryName: String?
    private let helper: HelperWeatherDetails = HelperWeatherDetails()

    private var windText: String {
        String(
            format: "%.1f %@",
            windSpeedConverter ?? 0.0,
            windSpeedUnit.shortName
        )
    }
    

    var body: some View {
        VStack(alignment:.center){
       
            
            VStack(spacing: 16) {
                if let weather = currentWeather {
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
                    Text(
                        String(format: "%.0f %@", weather.main.temp, temperatureUnit.displayShort)
                    )
                    .font(.largeTitle)
                    Text(weather.weather.first?.description ?? "")
                }
              
            }
            
            HStack{
                if let weather = currentWeather{
                    //Text(weather.weather.first?.description ?? "")
                    //weatherIcon(weather.weather.first?.icon.weatherIconURL)
                    VStack{
                        HStack{
                            Text("Today").font(.headline)
                            Text(helper.formattedDate(from: weather.dt, timezone: weather.timezone)  )
                            Text(helper.formattedTime(from: weather.dt, timezone: weather.timezone)  )
                        }
                        HStack{
                            CardView(
                                icon: Image(systemName: "wind"),
                                title: windText,
                                subtitle: "Wind"
                            )
                            CardView(
                                icon:Image(systemName: "drop.fill"),
                                title: String(format: "%d%%", weather.main.humidity),
                                subtitle: "Humidity"
                            )
                            
                            CardView(
                                icon: Image(systemName: "gauge"),
                                title: "\(weather.main.pressure) hPa",
                                subtitle: "Pressure"
                            )
                            
                       
                        }
                        HStack{
                            if let population = forecast?.city.population {
                                CardView(
                                    icon: Image(systemName: "person.2.fill"),
                                    title: "\(population)",
                                    subtitle: "Person"
                                )
                            }

                            CardView(
                                icon:Image(systemName: "thermometer"),
                                title: String(format: "%.0f %@", weather.main.feels_like,temperatureUnit.displayShort),
                                subtitle: "Feels like"
                            )
                            
                            CardView(
                                icon: Image(systemName: "cloud.fill"),
                                title: String(format: "%d%%", weather.clouds.all),
                                subtitle: "Cloudiness"
                            )
                        }
                        
                    }
                    
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
