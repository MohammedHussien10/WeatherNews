//
//  WeatherService.swift
//  WeatherNews
//
//  Created by Macos on 01/11/2025.
//

import Foundation
import KeychainSwift

protocol WeatherServiceProtocol{
    func fetchCurrentWeather(latitude:Double,longitude:Double)async throws ->WeatherResponse
}


final class WeatherApiService{
    private let keychain = KeychainSwift()
    func fetchCurrentWeather(latitude:Double,longitude:Double)async throws -> WeatherResponse{
        guard let apikey = keychain.get("AccessTokenWeatherKey") else {
            throw APIError.missingToken
        }
       let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apikey)"
        return try await fetchData(from: urlString)
    }
    
    func fetchForecast(latitude:Double,longitude:Double) async throws -> ForecastResponse {
        guard let apikey = keychain.get("AccessTokenWeatherKey") else {
            throw APIError.missingToken
        }
          let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(apikey)"
          return try await fetchData(from: urlString)
      }
    
    private func fetchData<T: Codable>(from urlString: String) async throws -> T{
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        do{
            let (data,response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse
            else {
                throw APIError.httpError(-1)
            }
                    
            guard 200..<300 ~= httpResponse.statusCode else{
                throw APIError.httpError(httpResponse.statusCode)
            }
            return try JSONDecoder().decode(T.self, from: data)
            
        }catch let urlError as URLError{
            throw APIError.urlSessionError(urlError)
        }catch let decodingError as DecodingError{
            throw APIError.decodingError
        }catch {
            throw APIError.unknown(error)
        }
        

   
    }
    
    
}

// MARK: - Error Types Enum
enum APIError: Error {
    case invalidURL
    case httpError(Int)
    case decodingError
    case urlSessionError(Error)
    case unknown(Error)
    case missingToken
}

