//
//  RepositoryImpl.swift
//  WeatherNews
//
//  Created by Macos on 04/11/2025.
//

import Foundation
final class RepositoryImpl: Repository{
    
    let remoteDataSource : RemoteDataSource
    
    init(
        remoteDataSource: RemoteDataSource
    ) {
        self.remoteDataSource = remoteDataSource
        
    }
    
    func getCurrentWeather(category: WeatherCategory,unit:String,language:String) async throws -> WeatherResponse {
        return try await remoteDataSource.getCurrentWeather(category: category,unit: unit, language: language)
    }
    
    func getForecast(category: WeatherCategory,unit:String,language:String) async throws -> ForecastResponse {
        return try await remoteDataSource.getForecast(category: category,unit:unit, language: language)
    }
    
}
