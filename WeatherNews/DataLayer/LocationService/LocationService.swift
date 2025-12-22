//
//  LocationService.swift
//  WeatherNews
//
//  Created by Macos on 22/12/2025.
//

import Foundation
import CoreLocation

protocol LocationServiceProtocol {
    func requestCurrentLocation() async throws->CLLocationCoordinate2D
  
}

final class LocationService:NSObject,LocationServiceProtocol{
    
    private let manager = CLLocationManager()
    private var coutinuation:CheckedContinuation<CLLocationCoordinate2D,Error>?
    
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    func requestCurrentLocation() async throws -> CLLocationCoordinate2D {
        let status = manager.authorizationStatus
        
        switch status{
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case.denied,.restricted
            throw LocationError.permissionDenied
            
        default:
            break
        }
        
        return try await withCheckedThrowingContinuation{ continuation in
            self.coutinuation = continuation
            manager.requestLocation()
        }
    }
    
    
    
}

enum LocationError:LocalizedError{
        case permissionDenied
        case failed

        var errorDescription:String?{
            switch self{
            case .permissionDenied:
                return "Location permission denied"
            case .failed:
                return "Failed to get location"
            }
        }


    }


extension LocationService: CLLocationManagerDelegate {
    func locationManager(manager:CLLocationManager,didUpdateLocations locations:[CLLocation]){
        guard let location = locations.last else{
            coutinuation?.resume(throwing: LocationError.failed)
            return
        }
        
        coutinuation?.resume(returning: location.coordinate)
        coutinuation = nil
    }
    func locationManager(manager:CLLocationManager,didFailWithError error: Error){
        coutinuation?.resume(throwing: error)
        coutinuation = nil
    }
}
