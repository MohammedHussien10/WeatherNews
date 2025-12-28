




import SwiftUI 

struct WeatherDetailsView<VM: WeatherDetailsVMProtocol>: View {
    @ObservedObject var viewModel: VM
    
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
        }.navigationBarTitleDisplayMode(.inline).task{
            await viewModel.loadCachedOrFetch(latitude: nil, longitude:nil)
        }.refreshable {
            await viewModel.refresh(latitude: viewModel.lat,
                                     longitude: viewModel.long)
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
