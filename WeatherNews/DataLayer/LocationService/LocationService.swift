import Foundation
import CoreLocation

protocol LocationServiceProtocol {
    func requestCurrentLocation() async throws->CLLocationCoordinate2D
  
}

final class LocationService:NSObject,LocationServiceProtocol{
    
    private let manager = CLLocationManager()
    private var continuation:CheckedContinuation<CLLocationCoordinate2D,Error>?
    
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    func requestCurrentLocation() async throws -> CLLocationCoordinate2D {

          guard continuation == nil else {
              throw LocationError.failed
          }

          let status = manager.authorizationStatus

          switch status {
          case .notDetermined:
              manager.requestWhenInUseAuthorization()

          case .authorizedWhenInUse, .authorizedAlways:
              break

          case .denied, .restricted:
              throw LocationError.permissionDenied

          @unknown default:
              throw LocationError.failed
          }

          return try await withCheckedThrowingContinuation { continuation in
              self.continuation = continuation
              if status == .authorizedWhenInUse || status == .authorizedAlways {
                  self.manager.requestLocation()
              }
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

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus

        if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.requestLocation()
        } else if status == .denied || status == .restricted {
            continuation?.resume(throwing: LocationError.permissionDenied)
            continuation = nil
        }
    }

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.last else {
            continuation?.resume(throwing: LocationError.failed)
            continuation = nil
            return
        }

        continuation?.resume(returning: location.coordinate)
        continuation = nil
    }

    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        continuation?.resume(throwing: error)
        continuation = nil
    }
}

