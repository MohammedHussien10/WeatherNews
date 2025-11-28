//
//  ApiManager.swift
//  WeatherNews
//
//  Created by Macos on 31/10/2025.
//

import Foundation

import KeychainSwift


final class AccessTokenManager{
    
    static let shared = AccessTokenManager()
    private let keychain = KeychainSwift()
    private let accessTokenWeather = "AccessTokenWeatherKey"
    
    private init(){
    }
    
    
    func saveAccessTokenWeather(accessToken: String){
        keychain.set(accessToken, forKey: accessTokenWeather)
    }
    
    func getAccessTokenWeather() -> String?{
        return keychain.get(accessTokenWeather)
    }
    
    
}

