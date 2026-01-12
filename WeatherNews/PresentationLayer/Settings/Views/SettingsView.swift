

import SwiftUI
// MARK: - Views
struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("temperatureUnit") private var temperatureUnitRawValue: String = TemperatureUnit.celsius.rawValue
    @AppStorage("windSpeedUnit") private var windSpeedUnitRawValue: String = WindSpeedUnit.meterPerSecond.rawValue
    @AppStorage("appLanguage") private var languageRawValue: String = AppLanguage.english.rawValue
    @AppStorage("locationMode") private var locationRawValue: String = LocationMode.none.rawValue
    @EnvironmentObject var languageManager: LanguageManager
    @State private var showMap = false
    @EnvironmentObject var homeViewModel: HomeViewModel
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                HStack{
                    Text("dark_mode".localized).font(.headline)
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
                PickerCard(title: "temperature_unit".localized, selectedOption: Binding(
                    get: { TemperatureUnit(rawValue: temperatureUnitRawValue) ?? .celsius },
                    set: { temperatureUnitRawValue = $0.rawValue }
                )).onChange(of: temperatureUnitRawValue) { _ in
                    Task { await homeViewModel.fetchWeather(latitude: homeViewModel.savedLat,
                                                            longitude: homeViewModel.savedLon) }
                }
                
                
                
                PickerCard(title: "wind_speed_unit".localized, selectedOption: Binding(
                    get: { WindSpeedUnit(rawValue: windSpeedUnitRawValue) ?? .meterPerSecond },
                    set: { windSpeedUnitRawValue = $0.rawValue }
                )).onChange(of: windSpeedUnitRawValue) { _ in
                    homeViewModel.refetchWindSpeed()
                }
                
                PickerCard(title: "language".localized, selectedOption: Binding(
                    get: { AppLanguage(rawValue: languageRawValue) ?? .english },
                    set: { newValue in
                        languageRawValue = newValue.rawValue
                        languageManager.setLanguage(newValue)
                    }
                )).onChange(of: languageRawValue) { _ in
                    Task { await homeViewModel.fetchWeather(latitude: homeViewModel.savedLat,
                                                            longitude: homeViewModel.savedLon) }
                }
                VStack(spacing: 16) {
                    
                    Toggle("use_gps".localized, isOn: Binding(
                        get: { locationRawValue == LocationMode.gps.rawValue },
                        set: { isOn in
                                   locationRawValue = isOn ? LocationMode.gps.rawValue : LocationMode.none.rawValue
                               }
                    )).alert("location_permission_title".localized,
                             isPresented: $homeViewModel.showLocationPermissionAlert) {

                          Button("open_settings".localized) {
                              if let url = URL(string: UIApplication.openSettingsURLString) {
                                  UIApplication.shared.open(url)
                              }
                          }

                        Button("cancel".localized, role: .cancel) {
                            locationRawValue = LocationMode.none.rawValue
                        }

                      } message: {
                          Text("location_permission_message".localized)
                      }

                    
                    Toggle("use_map".localized, isOn: Binding(
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
                        showMap = false
                        Task { await homeViewModel.fetchWeatherUsingGPS() }
                        
                    case .map:
                        if !showMap {
                            showMap = true
                        }
                        
                    }
                    
                    
                }
                    
                    
                    
                    
                    InfoCard(title: "about_app".localized, subtitle: "Weather News v 1.0\nMade by Mohammed Hussien\nContact Me at:\nEmail: mohammedhussien10101010@gmail.com")
                    
                    
                    
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
            .navigationTitle("settings_title".localized)
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
    
    


extension View {
    func cardStyle() -> some View {
        self
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            .shadow(radius: 1)
    }
}
