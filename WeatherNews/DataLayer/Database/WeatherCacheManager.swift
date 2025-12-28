//
//  WeatherCacheManager.swift
//  WeatherNews
//
//  Created by Macos on 28/12/2025.
//

import Foundation

final class WeatherCacheManager {
    static let shared = WeatherCacheManager()
    private init() {}

    private let fileManager = FileManager.default
    private let cacheFileName = "weather_cache.json"
    // TTL بالثواني (مثلاً ساعة)
    private let cacheTTL: TimeInterval = 3600

    // in-memory cache
    private var cachedPayload: CachedWeather?

    private var cacheURL: URL {
        let folder = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        return folder.appendingPathComponent(cacheFileName)
    }

    // MARK: - Payload (wrapper)
    private struct CachedWeather: Codable {
        let weather: WeatherResponse
        let forecast: ForecastResponse
        let lastUpdated: Date
    }

    // MARK: - Save
    func save(weather: WeatherResponse, forecast: ForecastResponse) {
        let payload = CachedWeather(weather: weather, forecast: forecast, lastUpdated: Date())
        cachedPayload = payload

        do {
            let data = try JSONEncoder().encode(payload)
            try data.write(to: cacheURL, options: .atomic)
        } catch {
            print("WeatherCacheManager: Failed to save cache ->", error)
        }
    }

    // MARK: - Load (returns tuple or nil)
    func load() -> (WeatherResponse, ForecastResponse, Date)? {
        // check memory first
        if let payload = cachedPayload {
            return (payload.weather, payload.forecast, payload.lastUpdated)
        }

        // check disk
        guard fileManager.fileExists(atPath: cacheURL.path) else { return nil }

        do {
            let data = try Data(contentsOf: cacheURL)
            let payload = try JSONDecoder().decode(CachedWeather.self, from: data)
            cachedPayload = payload
            return (payload.weather, payload.forecast, payload.lastUpdated)
        } catch {
            print("WeatherCacheManager: Failed to load cache ->", error)
            return nil
        }
    }

    // MARK: - Clear
    func clear() {
        cachedPayload = nil
        try? fileManager.removeItem(at: cacheURL)
    }

    // MARK: - TTL validation
    func isCacheValid() -> Bool {
        if let payload = cachedPayload {
            return Date().timeIntervalSince(payload.lastUpdated) < cacheTTL
        }
        if let (_, _, lastUpdated) = load() {
            return Date().timeIntervalSince(lastUpdated) < cacheTTL
        }
        return false
    }

    // Optional helper to get cached objects (nil if not exist)
    func getCachedWeather() -> (WeatherResponse, ForecastResponse)? {
        if let payload = cachedPayload {
            return (payload.weather, payload.forecast)
        }
        if let (w, f, _) = load() {
            return (w, f)
        }
        return nil
    }
}
