
import SwiftUI

struct WeatherDetailsView<VM: WeatherDetailsVMProtocol>: View {
    @ObservedObject var viewModel: VM
    @State private var addToAlerts = false
    @State private var addToFavorites = false
    let fromFavorites: Bool
    @EnvironmentObject var alertsviewModel : AlertsViewModel
    @EnvironmentObject var favoritesViewModel : FavoritesViewModel
    @Environment(\.colorScheme) var colorScheme
    private var weatherMain: String {
        viewModel.currentWeather?.weather.first?.main ?? "Clear"
    }

    var weatherAnimation: String {
        guard let weather = viewModel.currentWeather?.weather.first?.main else { return "sunny" }
        switch weather.lowercased() {
        case "clear": return "sunny"
        case "clouds": return "cloudy"
        case "rain", "drizzle": return "rainy"
        case "snow": return "snowy"
        default: return "sunny"
        }
        
    }

    var body: some View {
        
        ZStack {
            backgroundForWeather(weatherMain)
                  .ignoresSafeArea().animation(.easeInOut(duration: 1), value: weatherMain)

            VStack {
                LottieView(animationName: weatherAnimation)
                    .frame(width: 150, height: 150)
               
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
            .toolbar {
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
                            .foregroundColor(Color.init(hex: "#5b5b5b"))
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
                                )      .foregroundColor(Color.init(hex: "#5b5b5b"))
                            }
                            .disabled(viewModel.lat == nil || viewModel.long == nil)
                        }
                    }
                }.navigationDestination(isPresented: $addToAlerts){
                    Alerts()
                }
                
         
                
            }
            
        }.refreshable {
            await viewModel.refresh(latitude: viewModel.lat,
                                    longitude: viewModel.long)
        }
    }
    
    private func backgroundForWeather(_ weather: String) -> some View {
        let isDark = colorScheme == .dark

        switch weather {
        case "Clear":
            return AnyView(
                LinearGradient(
                    colors: isDark
                    ? [.black, .blue]
                    : [.cyan.opacity(0.6), .blue.opacity(0.4)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )

        case "Clouds":
            return AnyView(
                LinearGradient(
                    colors: isDark
                    ? [.gray, .black]
                    : [.gray.opacity(0.4), .white],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )

        case "Rain":
            return AnyView(
                LinearGradient(
                    colors: isDark
                    ? [.black, .gray]
                    : [.gray.opacity(0.5), .blue.opacity(0.3)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )

        case "Snow":
            return AnyView(
                LinearGradient(
                    colors: isDark
                    ? [.white.opacity(0.4), .blue]
                    : [.white, .blue.opacity(0.2)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )

        default:
            return AnyView(Color(.systemBackground))
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

 

