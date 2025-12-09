//
//  UseCaseWeather.swift
//  WeatherNews
//
//  Created by Macos on 04/11/2025.
//

import Foundation

protocol UseCaseWeather{
    func getCurrentWeather(category:WeatherCategory,unit:String,language:String) async throws ->WeatherResponse
    func getForecast(category: WeatherCategory,unit:String,language:String) async throws -> ForecastResponse
    
    func addDataWeatherToFavs(dataWeather: FavouritesModel) async throws
    func removeDataWeatherFromFavs(id: UUID) async throws
    func getFavouritesDataWeather() async throws -> [FavouritesModel]
}
