
import Foundation
import SwiftUI
import MapKit
final class AlertsViewModel:ObservableObject{
    
    @Published var alerts:[WeatherAlert] = []
    @Published var cityOfAlert : String?
    @Published var pendingLat: Double?
    @Published var pendingLong: Double?
    @Published var isCreatingFromHome = false
    @Published var showToast = false
    @Published var toastMessage = ""
    @AppStorage("appLanguage") private var languageRawValue: String = AppLanguage.english.rawValue
    var language: AppLanguage {
        AppLanguage(rawValue: languageRawValue) ?? .english
    }
    private let storage: AlertsStorage
    var sortedAlerts: [WeatherAlert] {
        alerts.sorted {
            if $0.isActive != $1.isActive {
                return $0.isActive && !$1.isActive
            }
            return $0.date < $1.date
        }
    }


    init(storage: AlertsStorage = AlertsUserDefaultsStorage()) {
          self.storage = storage
          self.alerts = storage.load()
    }
    
    @MainActor
    func addAlert(
        city: String?,
        lat: Double?,
        long: Double?,
        dateOfAlert: Date,
        type: AlertType
    )->Bool {
        
        guard dateOfAlert > Date() else {
            toastMessage = "toast_future_time".localized
            showToast = true
            return false
        }
        
        
        guard let city, let lat, let long else { return false }

        let alert = WeatherAlert(
            id: UUID(),
            city: city,
            latitude: lat,
            longitude: long,
            date: dateOfAlert,
            type: type,
            isActive: true
        )

        alerts.append(alert)
        storage.save(alerts)
        AlertManager.shared.scheduleAlert(alert: alert)

        cityOfAlert = nil
        pendingLat = nil
        pendingLong = nil
        isCreatingFromHome = false
        return true
    }


    @MainActor
    func stopAlert(id: UUID) {
        AlertManager.shared.cancelAlert(id: id)
        
        guard let index = alerts.firstIndex(where: { $0.id == id }) else { return }
                alerts[index].isActive = false
        storage.save(alerts)
    }
    @MainActor
    func deleteAlert(id: UUID)async {
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
                ?? "unknown".localized
            }
        } catch {
            print("Reverse geocoding failed: \(error)")
        }
        
    
    }
    @MainActor
    func hasAlert(lat: Double?, long: Double?) -> Bool {
        guard let lat, let long else { return false }

        return alerts.contains { alert in
            abs(alert.latitude - lat) < 0.0001 &&
            abs(alert.longitude - long) < 0.0001 &&
            alert.isActive
        }
    }


    @MainActor
    func deleteAlertForLocation(lat: Double, long: Double) async {
        guard let alert = alerts.first(where: {
            abs($0.latitude - lat) < 0.0001 &&
            abs($0.longitude - long) < 0.0001
        }) else { return }

        await deleteAlert(id: alert.id)
    }

    func localizedDate(_ date: Date, language: AppLanguage) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: language.apiParameter)
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

}

protocol AlertsStorage {
    func load() -> [WeatherAlert]
    func save(_ alerts: [WeatherAlert])
}


final class AlertsUserDefaultsStorage: AlertsStorage {
    private let key = "weather_alerts"
    @MainActor
    func load() -> [WeatherAlert] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let alerts = try? JSONDecoder().decode([WeatherAlert].self, from: data)
        else { return [] }

        return alerts
    }
    @MainActor
    func save(_ alerts: [WeatherAlert]) {
        let data = try? JSONEncoder().encode(alerts)
        UserDefaults.standard.set(data, forKey: key)
    }
    

    
}
