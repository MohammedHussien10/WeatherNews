//
//  ContentView.swift
//  WeatherNews
//
//  Created by Macos on 21/10/2025.
//

import SwiftUI
import CoreData


struct WeatherContainer: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel
    @EnvironmentObject var alertsViewModel: AlertsViewModel
    var body: some View {
        TabView() {

            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("home".localized, systemImage: "cloud.sun.fill")
                  
            }


            NavigationStack {
                Alerts()
            }
            .tabItem {
                Label("weather_alerts".localized, systemImage: "alarm.fill")
                
            }
  

            NavigationStack {
                Favorites()
            }
            .tabItem {
                Label("favorites_title".localized, systemImage: "heart.fill")
                   
            }


            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("settings_title".localized, systemImage: "gearshape.fill")
                  
            }
       
        }.tint(Color(hex: "#10e372"))
    }
}


#Preview {
    WeatherContainer()
}
