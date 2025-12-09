//
//  MapView.swift
//  WeatherNews
//
//  Created by Macos on 05/11/2025.
//

import SwiftUI
import MapKit
struct MapView: View {
    let mode: MapMode
    let onSelect: (CLLocationCoordinate2D)->Void
    @EnvironmentObject var homeviewModel : HomeViewModel
    @EnvironmentObject var favoritesviewModel : FavoritesViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.7893, longitude: 21.0936), span: MKCoordinateSpan(latitudeDelta: 30, longitudeDelta: 30))
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
            if let weather = homeviewModel.currentWeather{
                return "\(weather.sys.country.fullCountryName), \(weather.name)"
            } else {
                return "Select a location"
            }
        case .favorites:
            return "Select a location"
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
                var cityName = "Unknown"
                var countryName = "Unknown"
                
                let location = CLLocation(latitude: selectedCoordinate.latitude, longitude: selectedCoordinate.longitude)
                let geocoder = CLGeocoder()
                if Task.isCancelled { return }
                do{
                    let placemarks = try await geocoder.reverseGeocodeLocation(location)
                    if let placemark = placemarks.first{
                        cityName = placemark.locality ?? placemark.subAdministrativeArea  ?? "Unknown"
                        countryName = placemark.country ?? "Unknown"
                        
                    }
                }catch{
                    print("Reverse geocoding failed: \(error)")
                }
                
                
                
                
                let fav = FavouritesModel(id: UUID(), country: countryName, city: cityName, latitude: selectedCoordinate.latitude, longitude: selectedCoordinate.longitude)
                
                
                let isDuplicate = favoritesviewModel.favorites.contains{ existing in
                    abs(existing.latitude - fav.latitude) < 0.0001 &&
                    abs(existing.longitude - fav.longitude) < 0.0001
                    
                }
                if !isDuplicate{
                    if Task.isCancelled { return }
                    await favoritesviewModel.addFavorite(place: fav)
                }else {
                    print("Favorite already exists!")
                }
                
                
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
}
