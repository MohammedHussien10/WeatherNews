

import Foundation
protocol LocalDataSource{
    
    func addDataWeatherToFavs(dataWeather: FavouritesModel) async throws
    func removeDataWeatherFromFavs(id: UUID) async throws
    func getFavouritesDataWeather() async throws -> [FavouritesModel]
}
