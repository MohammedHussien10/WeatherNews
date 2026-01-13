

import Foundation
import SwiftUI
import MapKit
final class HomeViewModel:ObservableObject,WeatherDetailsVMProtocol {
    
    @Published var currentWeather : WeatherResponse?
    @Published var forecast : ForecastResponse?
    @Published var windSpeedConverter : Double?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var fallbackCityName: String?
    @Published var fallbackCountryName: String?
    @Published var locationSource: LocationSource = .gps
    @Published var showLocationPermissionAlert = false
    @AppStorage("savedLat") var savedLat: Double = 30.0444
    @AppStorage("savedLon") var savedLon: Double = 31.2357
    var lat: Double?
    var long: Double?
    @AppStorage("temperatureUnit") private var temperatureUnitRawValue: String = TemperatureUnit.celsius.rawValue
    @AppStorage("windSpeedUnit") private var windSpeedUnitRawValue: String = WindSpeedUnit.meterPerSecond.rawValue
    @AppStorage("appLanguage") private var languageRawValue: String = AppLanguage.english.rawValue
    
    var temperatureUnit: TemperatureUnit {
        TemperatureUnit(rawValue: temperatureUnitRawValue) ?? .celsius
    }
    
    
    var windSpeedUnit: WindSpeedUnit {
        get { WindSpeedUnit(rawValue: windSpeedUnitRawValue) ?? .meterPerSecond }
        set {
            windSpeedUnitRawValue = newValue.rawValue
            refetchWindSpeed()
        }
    }
    
    
    var language: AppLanguage {
        AppLanguage(rawValue: languageRawValue) ?? .english
    }
    
    private let locationService: LocationServiceProtocol
    private let getWeatherUseCase: UseCaseWeather
    private let helper: HelperWeatherDetails = HelperWeatherDetails()
    private var fetchTask: Task<Void, Never>?
    init(getWeatherUseCase: UseCaseWeather,locationService: LocationServiceProtocol = LocationService()) {
        self.getWeatherUseCase = getWeatherUseCase
        self.locationService = locationService
    }
    
    @MainActor
    func fetchWeather(latitude:Double,longitude:Double) async {
        if Task.isCancelled { return }
        self.lat = latitude
        self.long = longitude
        let unitTemp = temperatureUnit.apiParameter
        let appLanguage = language.apiParameter
        isLoading = true
        errorMessage = nil
        fallbackCityName = nil
        fallbackCountryName = nil
        do{
            async let currentWeatherData = try getWeatherUseCase.getCurrentWeather(category: .latandLong(latitude, longitude),unit:unitTemp,language:appLanguage)
            async let forecastData = try getWeatherUseCase.getForecast(category: .latandLong(latitude, longitude),unit:unitTemp,language:appLanguage)
            
            let (weatherResponse,forecastResponse) = try await (currentWeatherData,forecastData)
            if Task.isCancelled { return }
            self.currentWeather = weatherResponse
            self.forecast = forecastResponse
            
            await resolveFallbackCityAndCountryIfNeeded(latitude: latitude,longitude: longitude)
            // save Cache
            WeatherCacheManager.shared.save(weather: weatherResponse, forecast: forecastResponse)
            
        }catch{
            self.errorMessage = error.localizedDescription
            if let (w,f,_) = WeatherCacheManager.shared.load() {
                self.currentWeather = w
                self.forecast = f
            }
        }
        isLoading = false
        windSpeedConverter = helper.convertWindSpeed(currentWeather?.wind.speed ?? 0.0, from: temperatureUnit, to: windSpeedUnit)
    }
    
    @MainActor
    func loadCachedOrFetch(latitude: Double?, longitude: Double?) async {
        fetchTask?.cancel()
        let lat: Double
        let lon: Double
        
        if let latitude, let longitude {
            lat = latitude
            lon = longitude
        } else {
            switch locationSource {
            case .gps:
                lat = savedLat
                lon = savedLon
            case .map:
                guard let mapLat = self.lat,
                      let mapLon = self.long else { return }
                lat = mapLat
                lon = mapLon
            }
        }
        
        self.lat = lat
        self.long = lon
        
        if WeatherCacheManager.shared.isCacheValid(),let (w,f) = WeatherCacheManager.shared.getCachedWeather(){
            self.currentWeather = w
            self.forecast = f
        }
        fetchTask = Task { [weak self] in
            guard let self = self else { return }
            await self.fetchWeather(latitude: lat, longitude: lon)
            self.fetchTask = nil
        }
        
    }
    
    @MainActor
    func refresh(latitude: Double?, longitude: Double?) async {
        fetchTask?.cancel()
        let lat = latitude ?? self.lat ?? savedLat
        let lon = longitude ?? self.long ?? savedLon
        fetchTask = Task { [weak self] in
            guard let self = self else { return }
            await self.fetchWeather(latitude: lat, longitude: lon)
            self.fetchTask = nil
        }
    }
    
    func refetchWindSpeed() {
        guard let speed = currentWeather?.wind.speed else { return }
        windSpeedConverter = helper.convertWindSpeed(speed, from: temperatureUnit, to: windSpeedUnit)
    }
    
    
    func formattedTime(from timestamp: Int, timezone: Int ,language: AppLanguage) -> String {
        helper.formattedTime(from: timestamp, timezone: timezone, language: language)
    }
    
    func formattedDate(from timestamp: Int, timezone: Int) -> String {
        helper.formattedDate(from: timestamp, timezone: timezone)
    }
    
    func getNextFiveDays(list: [ForecastItem]) -> [ForecastItem] {
        helper.getNextFiveDays(list: list)
    }
    
    @MainActor
    func resolveFallbackCityAndCountryIfNeeded(latitude: Double, longitude: Double) async {
        let needsFallback = currentWeather?.name?.isEmpty ?? true
        guard needsFallback else { return }
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            if let placemark = placemarks.first {
                fallbackCityName = placemark.locality ?? placemark.subAdministrativeArea ?? placemark.country ?? "Unknown"
                fallbackCountryName = placemark.country ?? "Unknown"
            }
        } catch {
            print("Reverse geocoding failed:", error)
        }
    }
    @MainActor
    func fetchWeatherUsingGPS() async {
        fetchTask?.cancel()
        do{
            let coordinate = try await locationService.requestCurrentLocation()
            
            savedLat = coordinate.latitude
            savedLon = coordinate.longitude
            lat = coordinate.latitude
            long = coordinate.longitude
            await fetchWeather(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
        }catch LocationError.permissionDenied {
            showLocationPermissionAlert = true
        }catch{
            print("GPS error:", error.localizedDescription)
        }
    }
    
    
    
    
    
    @MainActor
    func fetchWeatherFromMap(lat: Double, lon: Double) async {
        fetchTask?.cancel()
        locationSource = .map
        
        self.lat = lat
        self.long = lon
        
        await fetchWeather(latitude: lat, longitude: lon)
    }
    
    
    
}

enum LocationSource {
    case gps
    case map
}


struct HelperWeatherDetails {
    @AppStorage("appLanguage") private var languageRawValue: String = AppLanguage.english.rawValue
    var language: AppLanguage {
        AppLanguage(rawValue: languageRawValue) ?? .english
    }
    func getNextFiveDays (list:[ForecastItem]) -> [ForecastItem]{
        var result : [ForecastItem] = []
        var addedDates:Set<String> = []
        for item in list{
            let date = Date(timeIntervalSince1970: TimeInterval(item.dt))
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let dayString = formatter.string(from: date)
            
            if Calendar.current.isDate(date, inSameDayAs: Date() ){
                continue
            }
            
            if !addedDates.contains(dayString){
                addedDates.insert(dayString)
                result.append(item)
            }
            
            if result.count >= 6 {break}
        }
        return result
        
    }
    
    
    //Convert dt to Real Time Date
    
    func formattedTime(from timestamp: Int, timezone: Int ,  language: AppLanguage) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: timezone)
        formatter.locale = Locale(identifier: language.apiParameter)
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
        
        
    }
    
    //Convert dt to Real Time Time
    
    func formattedDate(from timestamp: Int, timezone: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        
        formatter.dateFormat = "E, d MMM"
        formatter.timeZone = TimeZone(secondsFromGMT: timezone)
        formatter.locale = Locale(identifier: language.apiParameter)
        
        return formatter.string(from: date)
    }
    //Convert convert WindSpeed
    
    func convertWindSpeed(_ speed: Double, from apiUnits: TemperatureUnit, to windUnit: WindSpeedUnit) -> Double {
        
        
        if apiUnits == .celsius || apiUnits == .kelvin {
            switch windUnit {
            case .meterPerSecond:
                return speed
            case .milesPerHour:
                return speed * 2.23694
            }
        }
        
        
        if apiUnits == .fahrenheit {
            switch windUnit {
            case .meterPerSecond:
                return speed / 2.23694
            case .milesPerHour:
                return speed
            }
        }
        
        return speed
    }
    
    
    func localizedTemperature(
        _ value: Double,
        unit: TemperatureUnit,
        language: AppLanguage
    ) -> String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        formatter.locale = Locale(identifier: language.apiParameter)
        
        let number = formatter.string(from: NSNumber(value: value)) ?? "\(Int(value))"
        return String(
            format: "temperature_value".localized,
            number,
            unit.displayShort
        )
    }
    
    func localizedNumber(
        _ value: Double,
        language: AppLanguage,
        fractionDigits: Int = 0
    ) -> String {
        
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: language.apiParameter)
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = fractionDigits
        
        return formatter.string(from: NSNumber(value: value))
        ?? "\(Int(value))"
    }
    
     func localizedInt(
        _ value: Int,
        language: AppLanguage
    ) -> String {
        
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: language.apiParameter)
        formatter.numberStyle = .decimal
        
        return formatter.string(from: NSNumber(value: value))
        ?? "\(value)"
    }
    
    
    
}
// MARK: - Units Enums
enum TemperatureUnit: String, SettingOption {
    case kelvin = "Kelvin (°K)"
    case celsius = "Celsius (°C)"
    case fahrenheit = "Fahrenheit (°F)"
    
    var id: String { rawValue }
    var displayName: String {
        switch self {
        case .kelvin:
            return "temp_kelvin".localized
        case .celsius:
            return "temp_celsius".localized
        case .fahrenheit:
            return "temp_fahrenheit".localized
        }
    }
    
    
    var apiParameter: String {
        switch self {
        case .kelvin: return "standard"
        case .celsius: return "metric"
        case .fahrenheit: return "imperial"
        }
    }
    
    var displayShort: String {
        switch self {
        case .celsius:
            return "temp_celsius_short".localized
        case .fahrenheit:
            return "temp_fahrenheit_short".localized
        case .kelvin:
            return "temp_kelvin_short".localized
        }
    }
    
}

enum WindSpeedUnit: String, SettingOption {
    case meterPerSecond = "Meter/Sec"
    case milesPerHour = "Miles/Hour"
    
    var id: String { rawValue }
    var displayName: String {
        switch self {
        case .meterPerSecond:
            return "wind_meter_sec".localized
        case .milesPerHour:
            return "wind_miles_hour".localized
        }
    }
    
    var shortName: String {
        switch self {
        case .meterPerSecond: return "wind_unit_mps_short".localized
        case .milesPerHour: return "wind_unit_mph_short".localized
        }
    }
    
}


enum AppLanguage: String, SettingOption,CaseIterable {
    case english = "en"
    case arabic = "ar"
    
    var id: String { rawValue }
    var displayName: String {
        switch self {
        case .english: return "english".localized
        case .arabic: return "arabic".localized
        }
    }
    
    var apiParameter: String {
        switch self {
        case .english: return "en"
        case .arabic: return "ar"
        }
    }
}

enum LocationMode: String, SettingOption {
    case gps = "GPS"
    case map = "Map"
    case none = "None"
    
    var id: String { rawValue }
    var displayName: String { rawValue }
    
}

// MARK: - Protocol to for Make Options Generic

protocol SettingOption: CaseIterable,Identifiable,RawRepresentable,Hashable where RawValue == String{
    var displayName:String{get}
}

