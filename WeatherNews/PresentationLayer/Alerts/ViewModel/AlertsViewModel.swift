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
    
    func addAlert(city: String, start: Date,end: Date, type: AlertType) {
        
        let alert = WeatherAlert(id: UUID(), city: city, startDate: start, endDate: end, type: type, isActive: true)
        
        alerts.append(alert)
        AlertManager.shared.scheduleAlert(alert: alert)
    }
    
    func stopAlert(id: UUID) {
        AlertManager.shared.cancelAlert(id: id)
        
        if let index = alerts.firstIndex(where: {$0.id == id}){
            alerts[index].isActive = false
        }
    }
    
}
