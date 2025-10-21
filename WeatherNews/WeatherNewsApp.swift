//
//  WeatherNewsApp.swift
//  WeatherNews
//
//  Created by Macos on 21/10/2025.
//

import SwiftUI

@main
struct WeatherNewsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
