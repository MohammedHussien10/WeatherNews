//
//  RemoteDataSource.swift
//  WeatherNews
//
//  Created by Macos on 06/12/2025.
//

import Foundation
protocol LocalDataSource{
    
    func addDataWeatherToFavs(dataWeather: FavouritesModel) async throws
    func removeDataWeatherFromFavs(id: UUID) async throws
    func getFavouritesDataWeather() async throws -> [FavouritesModel]
}
