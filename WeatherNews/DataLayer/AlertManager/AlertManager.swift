//
//  AlertManager.swift
//  WeatherNews
//
//  Created by Macos on 16/12/2025.
//

import Foundation
import UserNotifications
import SwiftUI

final class AlertManager {
    static var shared = AlertManager()
    
    private init(){}
    
    func requestPermission() async{
        try? await UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound])
    }
    func scheduleAlert(alert: WeatherAlert) {
        
        let content = UNMutableNotificationContent()
        content.title = "Weather Alert"
        content.body = "Weather alert for \(alert.city)"
        
        switch alert.type{
            
        case .notification:
            content.sound = .default
        case .alarm:
            content.sound = .defaultCritical
        }
        
        let trigger  = UNTimeIntervalNotificationTrigger(timeInterval: max( alert.startDate.timeIntervalSinceNow,5), repeats: false)
        
        
        let request = UNNotificationRequest(identifier: alert.id.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
        
    }
    
    func cancelAlert(id: UUID) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id.uuidString])
    }
    
  
    
}

















enum AlertType: String, Codable, CaseIterable {
    case notification
    case alarm
}

struct WeatherAlert: Identifiable, Codable {
    let id: UUID
    let city: String
    let startDate: Date
    let endDate: Date
    let type: AlertType
    var isActive: Bool
}
