//
//  File.swift
//  WeatherNews
//
//  Created by Macos on 25/11/2025.
//

import Foundation
import SwiftUI
import MapKit
final class FavoritesViewModel:ObservableObject{
    @Published var favorites:[FavouritesModel] = []

     let getWeatherUseCase: UseCaseWeather
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
    
    func resolveFallbackCityAndCountryIfNeeded(lat: Double, long: Double) async{
        var cityName = "Unknown"
        var countryName = "Unknown"
        
        let location = CLLocation(latitude: lat, longitude: long)
        let geocoder = CLGeocoder()
        if Task.isCancelled { return }
        do{
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            if let placemark = placemarks.first{
                cityName = placemark.locality ?? placemark.subAdministrativeArea  ?? "Unknown"
                countryName = placemark.country ?? "Unknown"
                
            }
        }catch{
            print("Reverse geocoding failed: \(error)")
        }
        
        let fav = FavouritesModel(id: UUID(), country: countryName, city: cityName, latitude: lat, longitude: long)
        
        
        let isDuplicate = favorites.contains{ existing in
            abs(existing.latitude - fav.latitude) < 0.0001 &&
            abs(existing.longitude - fav.longitude) < 0.0001
            
        }
        if !isDuplicate{
            if Task.isCancelled { return }
            await addFavorite(place: fav)
        }else {
            print("Favorite already exists!")
        }
    }
    
    
}
