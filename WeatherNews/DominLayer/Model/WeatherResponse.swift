//
//  WeatherNews
//
//  Created by Macos on 31/10/2025.
//

import Foundation

struct WeatherResponse:Codable{
    let id: Int
    let name:String
    let main:Main
    let dt:Int
    let coord:Coord
    let wind:Wind
    let clouds: Clouds
    let weather:[Weather]
    let sys: Sys
    let cod: Int
    let timezone: Int
}


struct Coord:Codable{
    let lon:Double
    let lat:Double
}

struct Weather:Codable{
    let id:Int
    let main:String
    let description:String
    let icon:String
 
}

struct Main:Codable{
    let temp:Double
    let humidity:Int
    let pressure :Int
}

struct Wind:Codable{
    let speed:Double
}

struct Clouds:Codable{
    let all:Int
}
struct Sys: Codable {
    let country: String
}


struct ForecastResponse:Codable{
    let cod: String
    let list: [ForecastItem]
    let city: City
}
struct ForecastItem:Codable{
    let dt: Int
    let dt_txt:String
    let main:Main
    let weather:[Weather]
    let wind:Wind
    let clouds: Clouds
}
struct City:Codable{
    let id:Int
    let name:String
    let coord:Coord
    let country :String
    let timezone: Int
}
