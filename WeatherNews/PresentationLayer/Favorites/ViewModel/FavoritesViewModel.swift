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
    @Published var showToast = false
    @Published var toastMessage = ""

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
    @MainActor
    func addFavorite(place: FavouritesModel) async {
         do {
             try await getWeatherUseCase.addDataWeatherToFavs(dataWeather: place)
             await loadFavorites()
         } catch {
             print("Error adding favorite: \(error)")
         }
     }
    @MainActor
    func deleteFavorite(id: UUID) async {
         do {
             try await getWeatherUseCase.removeDataWeatherFromFavs(id: id)
             await loadFavorites()
         } catch {
             print("Error deleting favorite: \(error)")
         }
     }
    @MainActor
    func resolveFallbackCityAndCountryIfNeeded(lat: Double, long: Double) async{
        var cityName = "unknown".localized
        var countryName = "unknown".localized
        
        let location = CLLocation(latitude: lat, longitude: long)
        let geocoder = CLGeocoder()
        if Task.isCancelled { return }
        do{
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            if let placemark = placemarks.first{
                cityName = placemark.locality ?? placemark.subAdministrativeArea ?? placemark.country ?? "unknown".localized
                countryName = placemark.country ?? "unknown".localized
                
            }
        }catch{
            print("Reverse geocoding failed: \(error)")
        }
        
        let fav = FavouritesModel(id: UUID(), country: countryName, city: cityName, latitude: lat, longitude: long)
        
        
        let isDuplicate = favorites.contains{ existing in
            abs(existing.latitude - fav.latitude) < 0.0001 &&
            abs(existing.longitude - fav.longitude) < 0.0001
            
        }
        if !isDuplicate {
            if Task.isCancelled { return }
            await addFavorite(place: fav)
        } else {
            toastMessage = "toast_already_favorite".localized
            showToast = true
        }

    }
    @MainActor
    func isFavorite(lat: Double?, long: Double?) -> Bool {
        guard let lat, let long else { return false }

        return favorites.contains { fav in
            abs(fav.latitude - lat) < 0.0001 &&
            abs(fav.longitude - long) < 0.0001
        }
    }
    
    @MainActor
    func toggleFavorite(lat: Double?, long: Double?) async {
        guard let lat, let long else { return }

        if let existing = favorites.first(where: {
            abs($0.latitude - lat) < 0.0001 &&
            abs($0.longitude - long) < 0.0001
        }) {
            await deleteFavorite(id: existing.id)
        } else {
            await resolveFallbackCityAndCountryIfNeeded(lat: lat, long: long)
        }
    }


    
}
