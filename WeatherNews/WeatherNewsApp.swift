//
//  WeatherNewsApp.swift
//  WeatherNews
//
//  Created by Macos on 21/10/2025.
//

import SwiftUI

@main
struct WeatherNewsApp: App {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    let container = AppAssembly.container
     
    @StateObject var homeVM: HomeViewModel
     
    
    init(){
        if AccessTokenManager.shared.getAccessTokenWeather() == nil {
            AccessTokenManager.shared.saveAccessTokenWeather(accessToken: "bc43fd634d8d422aa4ef757a52c4eace")
        }
        
        let resolvedVM = container.resolve(HomeViewModel.self)!
        _homeVM = StateObject(wrappedValue: resolvedVM)
    }
    var body: some Scene {
        WindowGroup {
            WeatherContainer().preferredColorScheme(isDarkMode ? .dark : .light).environmentObject(homeVM)
        }
    }
    
    
}
