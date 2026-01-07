
import SwiftUI

struct WeatherDetailsView<VM: WeatherDetailsVMProtocol>: View {
    @ObservedObject var viewModel: VM
    @State private var addToAlerts = false
    @State private var addToFavorites = false
    let fromFavorites: Bool
    @EnvironmentObject var alertsviewModel : AlertsViewModel
    @EnvironmentObject var favoritesViewModel : FavoritesViewModel
    var body: some View {
        
        ZStack {
            WeatherAnimationView()
            ScrollView(.vertical,showsIndicators: false){
                if viewModel.isLoading {
                    CircleLoading()
                    
                }else{
                    VStack(alignment:.center,spacing: 16) {
                        
                        GeneralDetails(
                            currentWeather: viewModel.currentWeather,
                            forecast:viewModel.forecast,
                            windSpeedConverter: viewModel.windSpeedConverter,
                            temperatureUnit: viewModel.temperatureUnit,
                            windSpeedUnit: viewModel.windSpeedUnit,
                            fallbackCityName: viewModel.fallbackCityName,
                            fallbackCountryName: viewModel.fallbackCountryName
                        )
                        HourlyDetails(
                            forecast: viewModel.forecast?.list,
                            timezone: viewModel.forecast?.city.timezone ?? 0,
                            temperatureUnit: viewModel.temperatureUnit
                        )
                        
                        NextFiveDays(
                            forecast: viewModel.forecast?.list,
                            timezone: viewModel.forecast?.city.timezone ?? 0,
                            temperatureUnit: viewModel.temperatureUnit
                        )
                        
                        
                        
                    }.frame(maxWidth: .infinity,maxHeight: .infinity)
                }
                
            }
            .task(id: viewModel.lat) {
                guard let lat = viewModel.lat,
                      let long = viewModel.long else { return }
                
                await alertsviewModel.getNameOfCityOrCountry(lat: lat, long: long)
            }
            .refreshable {
                await viewModel.refresh(latitude: viewModel.lat,
                                        longitude: viewModel.long)
            }.toolbar {
                if !fromFavorites{
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            guard let lat = viewModel.lat,
                                  let long = viewModel.long else { return }
                            
                            Task {
                                if alertsviewModel.hasAlert(lat: lat, long: long) {
                                    
                                    await alertsviewModel.deleteAlertForLocation(
                                        lat: lat,
                                        long: long
                                    )
                                } else {
                                    
                                    alertsviewModel.pendingLat = lat
                                    alertsviewModel.pendingLong = long
                                    alertsviewModel.isCreatingFromHome = true
                                    addToAlerts = true
                                }
                            }
                        }
                    label: {
                        Image(systemName:
                                alertsviewModel.hasAlert(
                                    lat: viewModel.lat,
                                    long: viewModel.long
                                )
                              ? "bell.fill"
                              : "bell"
                        )
                        .foregroundColor(.green)
                    }
                    .disabled(viewModel.lat == nil || viewModel.long == nil)
                    }
                    
                    
                    
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            Task {
                                await favoritesViewModel.toggleFavorite(
                                    lat: viewModel.lat,
                                    long: viewModel.long
                                )
                            }
                        } label: {
                            Image(systemName:
                                    favoritesViewModel.isFavorite(
                                        lat: viewModel.lat,
                                        long: viewModel.long
                                    )
                                  ? "heart.fill"
                                  : "heart"
                            ) .foregroundColor(.green)
                        }
                        .disabled(viewModel.lat == nil || viewModel.long == nil)
                    }
                }
            }.navigationDestination(isPresented: $addToAlerts){
                Alerts()
            }
            
            
        }
        
        
    }
    
}



protocol WeatherDetailsVMProtocol: ObservableObject {
    var currentWeather: WeatherResponse? { get }
    var forecast: ForecastResponse? { get }
    var windSpeedConverter: Double? { get }
    var temperatureUnit: TemperatureUnit { get }
    var windSpeedUnit: WindSpeedUnit { get }
    var isLoading: Bool { get }
    var fallbackCityName: String? { get }
    var fallbackCountryName: String? { get }
    var lat: Double? { get }
    var long: Double? { get }
    func refresh(latitude: Double?, longitude: Double?) async
    func loadCachedOrFetch(latitude: Double?, longitude: Double?) async
    
}

struct WeatherAnimationView: View {
    @State private var cloudOffset: CGFloat = -200
    @State private var rainOffset: CGFloat = 0
    @State private var sunRotation: Double = 0

    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue, .cyan],
                           startPoint: .top,
                           endPoint: .bottom)
                .ignoresSafeArea()


            Circle()
                .fill(.yellow)
                .frame(width: 80, height: 80)
                .offset(x: 100, y: -200)
                .rotationEffect(.degrees(sunRotation))
                .onAppear {
                    withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                        sunRotation = 360
                    }
                }

            CloudView()
                .offset(x: cloudOffset, y: -100)
                .onAppear {
                    withAnimation(.linear(duration: 30).repeatForever(autoreverses: false)) {
                        cloudOffset = 400
                    }
                }

            RainView()
                .offset(y: rainOffset)
                .onAppear {
                    withAnimation(.linear(duration: 0.5).repeatForever(autoreverses: false)) {
                        rainOffset = 20
                    }
                }
        }
    }
}

struct CloudView: View {
    var body: some View {
        HStack(spacing: -20) {
            Circle().fill(.white).frame(width: 60, height: 60)
            Circle().fill(.white).frame(width: 80, height: 80)
            Circle().fill(.white).frame(width: 60, height: 60)
        }
    }
}

struct RainView: View {
    var body: some View {
        GeometryReader { geo in
            ForEach(0..<30, id: \.self) { i in
                Capsule()
                    .fill(.blue.opacity(0.6))
                    .frame(width: 2, height: 15)
                    .position(x: CGFloat.random(in: 0...geo.size.width),
                              y: CGFloat.random(in: 0...geo.size.height))
            }
        }
    }
}
