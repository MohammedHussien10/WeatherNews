

import Foundation
import UserNotifications
import SwiftUI
@MainActor
final class AlertManager {
    static var shared = AlertManager()
    
    private init(){}
    
    func requestPermission() async{
        try? await UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound])
    }
    func scheduleAlert(alert: WeatherAlert) {
        
        let content = UNMutableNotificationContent()
        content.title = "weather_alert".localized
        content.body = String(
            format: "weather_alert_for".localized,
            alert.city
        )

        content.categoryIdentifier = "WEATHER_ALERT_CATEGORY"

 

        switch alert.type{
            
        case .notification:
            content.sound = UNNotificationSound(named: UNNotificationSoundName("Dik_Voice.wav"))
        case .alarm:
            content.sound = UNNotificationSound(named: UNNotificationSoundName("Battleship_alarm.wav"))
        }
        
        let trigger  = UNTimeIntervalNotificationTrigger(timeInterval: max( alert.date.timeIntervalSinceNow,5), repeats: false)
        
        
        let request = UNNotificationRequest(identifier: alert.id.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
        
    }
    
    func cancelAlert(id: UUID) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id.uuidString])
    }
    
    func setupNotificationCategories() {
        
        let cancelAction = UNNotificationAction(
            identifier: "CANCEL_ALERT_ACTION",
            title: "Cancel Alert",
            options: [.destructive]
        )

        let openAction = UNNotificationAction(
            identifier: "OPEN_APP_ACTION",
            title: "Open App",
            options: [.foreground]
        )

        let category = UNNotificationCategory(
            identifier: "WEATHER_ALERT_CATEGORY",
            actions: [cancelAction, openAction],
            intentIdentifiers: [],
            options: []
        )

        UNUserNotificationCenter.current().setNotificationCategories([category])
    }

    
}




@MainActor
final class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {

        let id = response.notification.request.identifier

        switch response.actionIdentifier {

        case "CANCEL_ALERT_ACTION":
             AlertManager.shared.cancelAlert(id: UUID(uuidString: id) ?? UUID())

        default:
            break
        }
    }
}

@MainActor
final class AppDelegate: NSObject, UIApplicationDelegate {

    let notificationDelegate = NotificationDelegate()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {

        UNUserNotificationCenter.current().delegate = notificationDelegate

        Task {
            AlertManager.shared.setupNotificationCategories()
        }

        return true
    }
}









enum AlertType: String, Codable, CaseIterable {
    case notification
    case alarm
    var displayName: String {
        switch self {
        case .notification:
            return "alarm".localized
        case .alarm:
            return "notification".localized
        }
        
    }
}


struct WeatherAlert: Identifiable, Codable {
    let id: UUID
    let city: String
    let latitude: Double
    let longitude: Double
    let date: Date
    let type: AlertType
    var isActive: Bool
}
