//
//  UseCaseWeatherImpl.swift
//  WeatherNews
//
//  Created by Macos on 04/11/2025.
//

import Foundation
final class UseCaseWeatherImpl:UseCaseWeather{
   
    

    
    let repo : Repository
    
    init(repo: Repository) {
        self.repo = repo
    }
    
    func getCurrentWeather(category: WeatherCategory,unit:String,language:String) async throws -> WeatherResponse {
       return try await repo.getCurrentWeather(category: category,unit: unit,language: language)
    }
    
    func getForecast(category: WeatherCategory,unit:String,language:String) async throws -> ForecastResponse {
        return try await repo.getForecast(category: category,unit:unit,language: language)
    }
}
