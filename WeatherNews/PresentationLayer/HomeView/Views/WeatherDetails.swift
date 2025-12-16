




import SwiftUI 

struct WeatherDetailsView<VM: WeatherDetailsVMProtocol>: View {
    @ObservedObject var viewModel: VM
    
    var body: some View { 
        
        if viewModel.isLoading || viewModel.currentWeather == nil || viewModel.forecast == nil  {
            CircleLoading()
        }else{
            VStack(alignment:.center,spacing: 16) {
                
                GeneralDetails(
                    currentWeather: viewModel.currentWeather,
                    windSpeedConverter: viewModel.windSpeedConverter,
                    temperatureUnit: viewModel.temperatureUnit,
                    windSpeedUnit: viewModel.windSpeedUnit
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
}
