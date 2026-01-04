//
//  Settings.swift
//  WeatherNews
//
//  Created by Macos on 21/10/2025.
//

import SwiftUI
// MARK: - Views
struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("temperatureUnit") private var temperatureUnitRawValue: String = TemperatureUnit.celsius.rawValue
    @AppStorage("windSpeedUnit") private var windSpeedUnitRawValue: String = WindSpeedUnit.meterPerSecond.rawValue
    @AppStorage("appLanguage") private var languageRawValue: String = AppLanguage.english.rawValue
    @AppStorage("locationMode") private var locationRawValue: String = LocationMode.none.rawValue
    @State private var showMap = false
    @EnvironmentObject var homeViewModel: HomeViewModel
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                HStack{
                    Text("Dark Mode").font(.headline)
                    Spacer()
                    Button(action: {
                        withAnimation(.easeInOut){
                            isDarkMode.toggle()
                        }
                    }){
                        Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill" )
                            .font(.title2)
                            .foregroundColor(isDarkMode ? .yellow : .blue)
                            .padding(8)
                            .background(
                                Circle().fill(Color(.secondarySystemBackground))
                                    .shadow(radius: 2)
                            )
                    }
                }
                .padding().background(Color(.secondarySystemBackground)).cornerRadius(12).shadow(radius: 1)
                PickerCard(title: "Temperature Unit", selectedOption: Binding(
                    get: { TemperatureUnit(rawValue: temperatureUnitRawValue) ?? .celsius },
                    set: { temperatureUnitRawValue = $0.rawValue }
                )).onChange(of: temperatureUnitRawValue) { _ in
                    Task { await homeViewModel.fetchWeather(latitude: homeViewModel.savedLat,
                                                            longitude: homeViewModel.savedLon) }
                }
                
                
                
                PickerCard(title: "Wind Speed Unit", selectedOption: Binding(
                    get: { WindSpeedUnit(rawValue: windSpeedUnitRawValue) ?? .meterPerSecond },
                    set: { windSpeedUnitRawValue = $0.rawValue }
                )).onChange(of: windSpeedUnitRawValue) { _ in
                    homeViewModel.refetchWindSpeed()
                }
                
                PickerCard(title: "Language", selectedOption: Binding(
                    get: { AppLanguage(rawValue: languageRawValue) ?? .english },
                    set: { languageRawValue = $0.rawValue }
                )).onChange(of: languageRawValue) { _ in
                    Task { await homeViewModel.fetchWeather(latitude: homeViewModel.savedLat,
                                                            longitude: homeViewModel.savedLon) }
                }
                VStack(spacing: 16) {
                    
                    Toggle("Use GPS Location", isOn: Binding(
                        get: { locationRawValue == LocationMode.gps.rawValue },
                        set: { isOn in
                                   locationRawValue = isOn ? LocationMode.gps.rawValue : LocationMode.none.rawValue
                               }
                    ))
                    
                    Toggle("Use Map Location", isOn: Binding(
                        get: { locationRawValue == LocationMode.map.rawValue },
                        set: { isOn in
                                 locationRawValue = isOn ? LocationMode.map.rawValue : LocationMode.none.rawValue
                             }
                    ))
                    
                }.cardStyle().onChange(of: locationRawValue) { mode in
                    let resolvedMode = LocationMode(rawValue: mode) ?? .gps
                    locationRawValue = resolvedMode.rawValue
                    
                    switch resolvedMode {
                    case .none:
                           break
                    case .gps:
                        Task { await homeViewModel.fetchWeatherUsingGPS() }
                        
                    case .map:
                        if !showMap {
                            showMap = true
                        }
                        
                    }
                    
                    
                }
                    
                    
                    
                    
                    InfoCard(title: "About App", subtitle: "Weather News v 1.0\nMade by Eng.Mohammed Hussien\nContact Me\nEmail: mohammedhussien10101010@gmail.com")
                    
                    
                    
                }
                .padding()
            }
            .navigationDestination(isPresented: $showMap) {
                MapView(mode: .settings) { coordinate in
                    locationRawValue = LocationMode.map.rawValue
                    Task {
                        await homeViewModel.fetchWeather(
                            latitude: coordinate.latitude,
                            longitude: coordinate.longitude
                        )
                    }
                }
                
            }
            .navigationTitle("Settings")
        }
    }
    
    
    
    struct PickerCard<Option:SettingOption>: View {
        let title: String
        @Binding var selectedOption:Option
        
        var body: some View {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Picker(title, selection: $selectedOption) {
                    
                    ForEach (Array(Option.allCases)
                    ){ option in
                        Text(option.displayName).tag(option)
                        
                    }
                }
                .pickerStyle(.segmented)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            .shadow(radius: 1)
        }
    }
    
    
    struct InfoCard: View {
        let title: String
        let subtitle: String
        
        var body: some View {
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title).font(.headline)
                Text(subtitle).font(.subheadline).foregroundColor(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            .shadow(radius: 1)
        }
    }
    
    
    
    //#Preview {
    //    let homeVM = HomeViewModel(getWeatherUseCase: UseCaseWeatherImpl(repo: RepositoryImpl(remoteDataSource: RemoteDataSourceImpl())))
    //    let settingsVM = SettingsViewModel(homeViewModel: homeVM)
    //    SettingsView(settingsViewModel: settingsVM)
    //}
    
    
    
    
    


extension View {
    func cardStyle() -> some View {
        self
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            .shadow(radius: 1)
    }
}
