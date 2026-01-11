
import Foundation
final class UseCaseWeatherImpl:UseCaseWeather{
 
    let repo : Repository
    init(repo: Repository) {
        self.repo = repo
    }
    
    func getCurrentWeather(category: WeatherCategory,unit:String,language:String) async throws -> WeatherResponse {
        try await repo.getCurrentWeather(category: category,unit: unit,language: language)
    }
    
    func getForecast(category: WeatherCategory,unit:String,language:String) async throws -> ForecastResponse {
         try await repo.getForecast(category: category,unit:unit,language: language)
    }
    
    //localData
    
    func addDataWeatherToFavs(dataWeather: FavouritesModel) async throws {
        try await repo.addDataWeatherToFavs(dataWeather: dataWeather)
    }
    
    func removeDataWeatherFromFavs(id: UUID) async throws {
        try await repo.removeDataWeatherFromFavs(id: id)
    }
    
    func getFavouritesDataWeather() async throws -> [FavouritesModel] {
        try await repo.getFavouritesDataWeather()
    }
    
}
