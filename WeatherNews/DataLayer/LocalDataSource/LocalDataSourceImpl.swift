

import Foundation
class LocalDataSourceImpl:LocalDataSource{
    
   private let db = DataBaseManager.shared

    
    func getFavouritesDataWeather() async throws -> [FavouritesModel] {
            try await db.getAllFavouries()
    }
    
    func addDataWeatherToFavs(dataWeather: FavouritesModel) async throws {
            try await db.addToFavouries(place: dataWeather)
    }
    
    func removeDataWeatherFromFavs(id: UUID) async throws {
            try await db.deleteFromFavouries(placeId: id)
    }
 
    
    
}
