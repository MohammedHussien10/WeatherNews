




import SwiftUI 

struct WeatherDetailsView<VM: WeatherDetailsVMProtocol>: View {
    @ObservedObject var viewModel: VM
    @State private var addToAlerts = false
    @State private var addToFavorites = false
    let fromFavorites: Bool
    @EnvironmentObject var alertsviewModel : AlertsViewModel
    @EnvironmentObject var favoritesViewModel : FavoritesViewModel
    var body: some View {
        Group{
            if viewModel.currentWeather == nil || viewModel.forecast == nil  {
                CircleLoading()
            }else{
                VStack(alignment:.center,spacing: 16) {
                    
                    GeneralDetails(
                        currentWeather: viewModel.currentWeather,
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
                    
                    
                    
                }.frame(maxWidth: .infinity,maxHeight: .infinity).background( LinearGradient( colors: [Color.blue, Color.cyan], startPoint: .topLeading, endPoint: .bottomTrailing ).ignoresSafeArea() )
                
                
                
            }
        }
.navigationBarTitleDisplayMode(.inline).task(id: viewModel.lat) {
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
    
    

//#Preview {
//    
//    WeatherDetailsView()
//        
//        
//    }
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
