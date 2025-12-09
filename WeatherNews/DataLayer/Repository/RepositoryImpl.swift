//
//  RepositoryImpl.swift
//  WeatherNews
//
//  Created by Macos on 04/11/2025.
//

import Foundation
final class RepositoryImpl: Repository{

    
    
    let remoteDataSource : RemoteDataSource
    let localDataSource : LocalDataSource
    init(
        remoteDataSource: RemoteDataSource,
        localDataSource : LocalDataSource
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    func getCurrentWeather(category: WeatherCategory,unit:String,language:String) async throws -> WeatherResponse {
        return try await remoteDataSource.getCurrentWeather(category: category,unit: unit, language: language)
    }
    
    func getForecast(category: WeatherCategory,unit:String,language:String) async throws -> ForecastResponse {
        return try await remoteDataSource.getForecast(category: category,unit:unit, language: language)
    }
    
    // localData
    func addDataWeatherToFavs(dataWeather: FavouritesModel) async throws {
      try await  localDataSource.addDataWeatherToFavs(dataWeather: dataWeather)
    }
    
    func removeDataWeatherFromFavs(id: UUID) async throws {
        try await  localDataSource.removeDataWeatherFromFavs(id: id)
    }
    
    func getFavouritesDataWeather() async throws -> [FavouritesModel] {
        try await  localDataSource.getFavouritesDataWeather()
    }
    
    
}
