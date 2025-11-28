//
//  FavouritesModel.swift
//  WeatherNews
//
//  Created by Macos on 25/11/2025.
//

import Foundation
import MapKit

struct FavouritesModel: Identifiable, Codable {
    let id: UUID
    let country: String
    let city: String
    let latitude: Double
    let longitude: Double
    
    var coordinate : CLLocationCoordinate2D{
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
extension WeatherEntity {
    func toModel() -> FavouritesModel {
   FavouritesModel(id: id ?? UUID(), country: country ?? "", city: city ?? "", latitude: latitude, longitude:longitude)
    }
}
