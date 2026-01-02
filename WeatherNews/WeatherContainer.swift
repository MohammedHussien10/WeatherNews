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
                Label("Home", systemImage: "cloud.sun.fill")
                  
            }


            NavigationStack {
                Alerts()
            }
            .tabItem {
                Label("Alerts", systemImage: "alarm.fill")
                
            }
  

            NavigationStack {
                Favorites()
            }
            .tabItem {
                Label("Favorites", systemImage: "heart.fill")
                   
            }


            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "gearshape.fill")
                  
            }
       
        }.tint(Color(hex: "#10e372"))
    }
}


#Preview {
    WeatherContainer()
}
