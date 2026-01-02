//
//  AlertsViewModel.swift
//  WeatherNews
//
//  Created by Macos on 16/12/2025.
//

import Foundation
import MapKit
final class AlertsViewModel:ObservableObject{
    
    @Published var alerts:[WeatherAlert] = []
    @Published var cityOfAlert : String?
    private let storage: AlertsStorage
    
    init(storage: AlertsStorage = AlertsUserDefaultsStorage()) {
          self.storage = storage
          self.alerts = storage.load()
    }
    
    @MainActor
    func addAlert(city: String?, dateOfAlert: Date, type: AlertType) {
        guard let city else { return }
        guard dateOfAlert > Date() else { return }

        let alert = WeatherAlert(
            id: UUID(),
            city: city,
            date: dateOfAlert,
            type: type,
            isActive: true
        )

        alerts.append(alert)
        storage.save(alerts)
        AlertManager.shared.scheduleAlert(alert: alert)
    }

    @MainActor
    func stopAlert(id: UUID) {
        AlertManager.shared.cancelAlert(id: id)
        
        guard let index = alerts.firstIndex(where: { $0.id == id }) else { return }
                alerts[index].isActive = false
        storage.save(alerts)
    }
    @MainActor
    func deleteAlert(id: UUID) {
         AlertManager.shared.cancelAlert(id: id)
         alerts.removeAll { $0.id == id }
         storage.save(alerts)
     }
    
    @MainActor
    func loadAlerts() async{
        alerts = storage.load()
     }
    @MainActor
    func getNameOfCityOrCountry(lat: Double, long: Double) async {
        let location = CLLocation(latitude: lat, longitude: long)
        let geocoder = CLGeocoder()
        
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            
            if let placemark = placemarks.first {
                cityOfAlert = placemark.locality
                    ?? placemark.subAdministrativeArea
                    ?? placemark.country
                    ?? "Unknown"
            }
        } catch {
            print("Reverse geocoding failed: \(error)")
        }
        
    
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
