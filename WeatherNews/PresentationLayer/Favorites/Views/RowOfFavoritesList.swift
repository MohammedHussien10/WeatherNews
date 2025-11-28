////
////  RowOfFavoritesList.swift
////  WeatherNews
////
////  Created by Macos on 25/11/2025.
////
//
//import SwiftUI
//
//struct RowOfFavoritesList: View {
//    var body: some View {
//        HStack(spacing: 2){
//            if let weather = viewModel.currentWeather{
//                Text("\(weather.sys.country.fullCountryName)").font(.largeTitle)
//                Text("\(weather.sys.country.fullCountryName),\(weather.name)").font(.title3)
//            }
//        }.background(Color.green)
//    }
//}
//
//#Preview {
//    RowOfFavoritesList()
//}
