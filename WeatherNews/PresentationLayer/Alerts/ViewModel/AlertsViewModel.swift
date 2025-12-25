//
//  AlertsViewModel.swift
//  WeatherNews
//
//  Created by Macos on 16/12/2025.
//

import Foundation
@MainActor
final class AlertsViewModel:ObservableObject{
    
    @Published var alerts:[WeatherAlert] = []
    
    private let storage: AlertsStorage
    
    init(storage: AlertsStorage = AlertsUserDefaultsStorage()) {
          self.storage = storage
          self.alerts = storage.load()
    }
    
    
    func addAlert(city: String, start: Date,end: Date, type: AlertType) {
        
        let alert = WeatherAlert(id: UUID(), city: city, startDate: start, endDate: end, type: type, isActive: true)
        
        alerts.append(alert)
        storage.save(alerts)
        AlertManager.shared.scheduleAlert(alert: alert)
    }
    
    func stopAlert(id: UUID) {
        AlertManager.shared.cancelAlert(id: id)
        
        guard let index = alerts.firstIndex(where: { $0.id == id }) else { return }
                alerts[index].isActive = false
        storage.save(alerts)
    }
    
}

protocol AlertsStorage {
    func load() -> [WeatherAlert]
    func save(_ alerts: [WeatherAlert])
}


final class AlertsUserDefaultsStorage: AlertsStorage {
    private let key = "weather_alerts"

    func load() -> [WeatherAlert] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let alerts = try? JSONDecoder().decode([WeatherAlert].self, from: data)
        else { return [] }

        return alerts
    }

    func save(_ alerts: [WeatherAlert]) {
        let data = try? JSONEncoder().encode(alerts)
        UserDefaults.standard.set(data, forKey: key)
    }
}
