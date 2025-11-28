//
//  RemoteDataSource.swift
//  WeatherNews
//
//  Created by Macos on 04/11/2025.
//

import Foundation

protocol RemoteDataSource{
    
    func getCurrentWeather(category:WeatherCategory,unit:String,language:String) async throws ->WeatherResponse
    func getForecast(category: WeatherCategory,unit:String,language:String) async throws -> ForecastResponse
}


