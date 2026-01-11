
import SwiftUI
import MapKit
struct MapView: View {
    let mode: MapMode
    let onSelect: (CLLocationCoordinate2D)->Void
    @EnvironmentObject var homeviewModel : HomeViewModel
    @EnvironmentObject var favoritesviewModel : FavoritesViewModel
    @EnvironmentObject var alertsviewModel : AlertsViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.7893, longitude: 21.0936), span: MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 50))
    @State private var isLoading = false
    @State private var weatherTask: Task<Void, Never>?
    
    var body: some View {
        
        ZStack {
            Map(coordinateRegion: $region, interactionModes: .all,showsUserLocation: true).ignoresSafeArea()
            
            Image(systemName: "mappin.circle.fill")
                .font(.system(size: 45))
                .foregroundColor(.red)
                .offset(y: -20)
            
            VStack {
                Spacer()
                
                VStack(spacing: 12) {
                    
                    Text(getLocationName())
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    Button("Select Location") {
                        Task {
                            await getLocation()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    
                    
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding()
            }
            
            
            if isLoading {
                CircleLoading()
            }
            
        }.onDisappear {
            weatherTask?.cancel()
            weatherTask = nil
        }
    }
    
    private func getLocationName() -> String {
        switch mode {
        case .settings:
            
            guard let weather = homeviewModel.currentWeather else {
                return "Select a location"
            }
            
            let country = weather.sys.country?.fullCountryName ?? homeviewModel.fallbackCountryName ?? "Unknown Country"
                let city: String
            if let name = weather.name, !name.isEmpty {
                    city = name
                } else {
                    city = homeviewModel.fallbackCityName ?? "Unknown City"
                }

                return "\(country), \(city)"
        case .favorites:
            return "Select a location To Favorites"
            
        case .alerts:
                return "Select a location To Alerts"
            }
  
  
    }
    
    
    func getLocation() async{
        weatherTask?.cancel()
        weatherTask = nil

   
        
        weatherTask = Task { @MainActor in
            defer {
                isLoading = false
            }
            
            
            isLoading = true
            
            let selectedCoordinate = region.center
            if Task.isCancelled { return }
            
            switch mode{
            case .settings:
                homeviewModel.savedLat = selectedCoordinate.latitude
                homeviewModel.savedLon = selectedCoordinate.longitude
                
                if Task.isCancelled { return }
                await homeviewModel.fetchWeather(
                    latitude: homeviewModel.savedLat,
                    longitude: homeviewModel.savedLon
                )
              

            case.favorites:
                await favoritesviewModel.resolveFallbackCityAndCountryIfNeeded(lat: selectedCoordinate.latitude, long: selectedCoordinate.longitude)
                
            case .alerts:
                
                alertsviewModel.pendingLat = selectedCoordinate.latitude
                alertsviewModel.pendingLong = selectedCoordinate.longitude
              await alertsviewModel.getNameOfCityOrCountry(lat: selectedCoordinate.latitude, long: selectedCoordinate.longitude)
                
            }
            if Task.isCancelled { return }
            onSelect(selectedCoordinate)
            try? await Task.sleep(nanoseconds: 300_000_000)
            dismiss()
            
        }
        
    }
}





struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}


enum MapMode {
    case favorites
    case settings
    case alerts
}
