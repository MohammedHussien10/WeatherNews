

import Foundation
class RemoteDataSourceImpl:RemoteDataSource{
  

    
    let apiService : WeatherApiService
    
    init(apiService: WeatherApiService = WeatherApiService.shared) {
        self.apiService = apiService
    }
    
  
    func getCurrentWeather(category: WeatherCategory,unit:String,language:String) async throws -> WeatherResponse {
        return try await apiService.fetchCurrentWeather(category: category,unit:unit, language: language)
    }
    
    func getForecast(category: WeatherCategory,unit:String,language:String) async throws -> ForecastResponse {
        return try await apiService.fetchForecast(category: category,unit:unit,language: language)
    }

}
