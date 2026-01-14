# WeatherNews iOS App

WeatherNews is a **native iOS weather application** built with **Swift & SwiftUI**, designed with clean architecture principles and a strong focus on **localization, scalability, and real-world production practices**.

The app provides real-time weather data, forecasts, favorites, alerts, and full Arabic/English localization — all wrapped in a clean, modern UI.

---

## All Features

### Weather

* Current weather conditions
* Hourly & Next 5 Days forecasts
* Feels-like temperature
* Wind speed, humidity, pressure, cloudiness
* Population & city details

### Location Handling

* Get weather using **GPS**
* Select location from **Map**
* Graceful permission handling ("Don’t Allow" case supported)

### Favorites

* Save favorite locations
* Persistent storage
* Easy access & management

### Weather Alerts

* Schedule weather alerts by time & location
* Notification & Alarm modes
* Custom notification sounds
* Actionable notifications (Cancel alert without opening the app)

### Localization

* Full **Arabic & English** support
* Localized:

  * Text
  * Numbers
  * Dates & times
  * Units (°C, °F, m/s, hPa, %)

### Settings

* Dark / Light mode
* Temperature unit (Celsius / Fahrenheit / Kelvin)
* Wind speed unit (m/s / mph)
* App language
* Location mode (GPS / Map)

---

## Architecture

The project follows **Clean Architecture** with clear separation of concerns:

```
Presentation (SwiftUI Views)
│
├── ViewModels (MVVM)
│
├── UseCases
│
├── Repositories
│
├── DataSources (Remote / Local)
│
└── Services (Location, Alerts, Networking)
```

### Patterns Used

* MVVM
* Repository Pattern
* Dependency Injection (DI Container)
* Protocol-Oriented Programming
* Singleton (where appropriate)

---

## Tech Stack

* **Language:** Swift
* **UI:** SwiftUI
* **Architecture:** MVVM + Clean Architecture
* **Networking:** REST APIs
* **Concurrency:** async / await
* **Dependency Injection:** Custom DI Container
* **Security:** Keychain (KeychainSwift)
* **Persistence:** UserDefaults
* **Location:** CoreLocation
* **Maps:** MapKit
* **Notifications:** UserNotifications
* **Image Loading:** Kingfisher

---

### UI & UX

* Dynamic background that adapts to current weather conditions
* Clean, modern SwiftUI design
* Smooth animations and transitions
* Custom app icon & launch screen

---

## Performance & Caching

* Custom cache manager using FileManager & Codable
* In-memory + disk cache fallback strategy
  
---

## APIs

* Weather data provided by a public Weather API
* Reverse geocoding for city & country names

---

## Demo

**Demo Video:** *(Add link here)*

**Screenshots:** *(Optional)*

---


## Made By:

**Mohammed Hussien**
Email: [mohammedhussien10101010@gmail.com](mailto:mohammedhussien10101010@gmail.com)
iOS Developer

