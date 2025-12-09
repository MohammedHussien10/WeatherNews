//
//  File.swift
//  WeatherNews
//
//  Created by Macos on 25/11/2025.
//

import Foundation

final class FavoritesViewModel:ObservableObject{
    @Published var favorites:[FavouritesModel] = []
    
    private let getWeatherUseCase: UseCaseWeather
    init(getWeatherUseCase: UseCaseWeather) {
        self.getWeatherUseCase = getWeatherUseCase
    }
    @MainActor
    func loadFavorites() async{
        do{ favorites = try await getWeatherUseCase.getFavouritesDataWeather()
        }catch{
            print("Error loading favorites: \(error)")
        }
    }
    
    func addFavorite(place: FavouritesModel) async {
         do {
             try await getWeatherUseCase.addDataWeatherToFavs(dataWeather: place)
             await loadFavorites()
         } catch {
             print("Error adding favorite: \(error)")
         }
     }
    
    func deleteFavorite(id: UUID) async {
         do {
             try await getWeatherUseCase.removeDataWeatherFromFavs(id: id)
             await loadFavorites()
         } catch {
             print("Error deleting favorite: \(error)")
         }
     }
    
    
}
