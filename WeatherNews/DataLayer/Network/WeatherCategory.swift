
import Foundation
enum WeatherCategory{
    
    case latandLong(Double,Double)
    
    var currentWeather:String{
        
        switch self {
            
        case .latandLong(let lat,let long):
            return "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)"
        }
        
    }
    
    var forecast:String{
        
        switch self {
            
        case .latandLong(let lat,let long):
            return "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(long)"
        }
        
    }
}
    

    
    

