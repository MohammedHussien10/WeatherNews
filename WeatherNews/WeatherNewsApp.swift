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
    @StateObject var languageManager = LanguageManager()
    let container = AppAssembly.container
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var homeVM: HomeViewModel
    @StateObject var favoritesVM: FavoritesViewModel
    @StateObject var alertsVM: AlertsViewModel
    init(){
        if AccessTokenManager.shared.getAccessTokenWeather() == nil {
            AccessTokenManager.shared.saveAccessTokenWeather(accessToken: "bc43fd634d8d422aa4ef757a52c4eace")
        }
        
        guard let resolvedHomeVM = container.resolve(HomeViewModel.self),
              let resolvedFavoritesVM = container.resolve(FavoritesViewModel.self),let resolvedAlertsVM = container.resolve(AlertsViewModel.self)
        else {
            fatalError("DI Error: Could not resolve ViewModels")
        }
        _homeVM = StateObject(wrappedValue: resolvedHomeVM)
        _favoritesVM = StateObject(wrappedValue: resolvedFavoritesVM)
        _alertsVM = StateObject(wrappedValue: resolvedAlertsVM)
    }
    var body: some Scene {
        WindowGroup {
            WeatherContainer().preferredColorScheme(isDarkMode ? .dark : .light).environmentObject(homeVM) .environmentObject(favoritesVM).task {
                await favoritesVM.loadFavorites()
            }.environmentObject(alertsVM).environmentObject(languageManager)
        }
    }
    
    
}
