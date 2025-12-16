//
//  HomeViewModel.swift
//  WeatherNews
//
//  Created by Macos on 31/10/2025.
//

import Foundation
import SwiftUI
final class HomeViewModel:ObservableObject,WeatherDetailsVMProtocol {
    @Published var currentWeather : WeatherResponse?
    @Published var forecast : ForecastResponse?
    @Published var windSpeedConverter : Double?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @AppStorage("savedLat") var savedLat: Double = 30.0444
    @AppStorage("savedLon") var savedLon: Double = 31.2357
    @AppStorage("temperatureUnit") private var temperatureUnitRawValue: String = TemperatureUnit.celsius.rawValue
    @AppStorage("windSpeedUnit") private var windSpeedUnitRawValue: String = WindSpeedUnit.meterPerSecond.rawValue
    @AppStorage("appLanguage") private var languageRawValue: String = AppLanguage.english.rawValue
    
    var temperatureUnit: TemperatureUnit {
        TemperatureUnit(rawValue: temperatureUnitRawValue) ?? .celsius
    }


    var windSpeedUnit: WindSpeedUnit {
        get { WindSpeedUnit(rawValue: windSpeedUnitRawValue) ?? .meterPerSecond }
        set {
            windSpeedUnitRawValue = newValue.rawValue
            refetchWindSpeed()
        }
    }


    var language: AppLanguage {
        AppLanguage(rawValue: languageRawValue) ?? .english
    }
    
    
    private let getWeatherUseCase: UseCaseWeather
    private let helper: HelperWeatherDetails = HelperWeatherDetails()
    init(getWeatherUseCase: UseCaseWeather) {
        self.getWeatherUseCase = getWeatherUseCase
    }
    
    @MainActor
    func fetchWeather(latitude:Double,longitude:Double) async {
        let unitTemp = temperatureUnit.apiParameter
        let appLanguage = language.apiParameter
        isLoading = true
        errorMessage = nil
        do{
            async let currentWeatherData = try getWeatherUseCase.getCurrentWeather(category: .latandLong(latitude, longitude),unit:unitTemp,language:appLanguage)
            async let forecastData = try getWeatherUseCase.getForecast(category: .latandLong(latitude, longitude),unit:unitTemp,language:appLanguage)
            
        let (weatherResponse,forecastResponse) = try await (currentWeatherData,forecastData)
            
            self.currentWeather = weatherResponse
            self.forecast = forecastResponse
        }catch{
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
        windSpeedConverter = helper.convertWindSpeed(currentWeather?.wind.speed ?? 0.0, from: temperatureUnit, to: windSpeedUnit)
    }
    
    
  
    
    func refetchWindSpeed() {
        guard let speed = currentWeather?.wind.speed else { return }
        windSpeedConverter = helper.convertWindSpeed(speed, from: temperatureUnit, to: windSpeedUnit)
    }
    

        func formattedTime(from timestamp: Int, timezone: Int) -> String {
            helper.formattedTime(from: timestamp, timezone: timezone)
        }

        func formattedDate(from timestamp: Int, timezone: Int) -> String {
            helper.formattedDate(from: timestamp, timezone: timezone)
        }

        func getNextFiveDays(list: [ForecastItem]) -> [ForecastItem] {
            helper.getNextFiveDays(list: list)
        }
    
    
}



struct HelperWeatherDetails {
    
    func getNextFiveDays (list:[ForecastItem]) -> [ForecastItem]{
        var result : [ForecastItem] = []
        var addedDates:Set<String> = []
        for item in list{
            let date = Date(timeIntervalSince1970: TimeInterval(item.dt))
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let dayString = formatter.string(from: date)
    
            if Calendar.current.isDate(date, inSameDayAs: Date() ){
                continue
            }
            
            if !addedDates.contains(dayString){
                addedDates.insert(dayString)
                result.append(item)
            }
            
            if result.count >= 6 {break}
        }
        return result
        
    }

    
    //Convert dt to Real Time Date
    
    func formattedTime(from timestamp: Int, timezone: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.timeZone = TimeZone(secondsFromGMT: timezone)
        return formatter.string(from: date)
    }

    //Convert dt to Real Time Time
    
    func formattedDate(from timestamp: Int, timezone: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
          let formatter = DateFormatter()
          
          formatter.dateFormat = "E, d MMM"
          formatter.timeZone = TimeZone(secondsFromGMT: timezone)
          formatter.locale = Locale.current
          
          return formatter.string(from: date)
    }

    //Convert convert WindSpeed
    
    func convertWindSpeed(_ speed: Double, from apiUnits: TemperatureUnit, to windUnit: WindSpeedUnit) -> Double {
        
     
        if apiUnits == .celsius || apiUnits == .kelvin {
            switch windUnit {
            case .meterPerSecond:
                return speed
            case .milesPerHour:
                return speed * 2.23694
            }
        }
        
        
        if apiUnits == .fahrenheit {
            switch windUnit {
            case .meterPerSecond:
                return speed / 2.23694
            case .milesPerHour:
                return speed
            }
        }
        
        return speed
    }

    
}
