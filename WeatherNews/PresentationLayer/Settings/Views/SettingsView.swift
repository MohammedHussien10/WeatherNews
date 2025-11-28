//
//  Settings.swift
//  WeatherNews
//
//  Created by Macos on 21/10/2025.
//

import SwiftUI

struct Settings: View {
    @State private var isDark = false
    @State private var useLocation = true
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ToggleCard(title: "Dark Mode", isOn: $isDark, icon: "moon.fill", color: .purple)
                ToggleCard(title: "Use Current Location", isOn: $useLocation, icon: "location.fill", color: .blue)
                InfoCard(title: "About App", subtitle: "WeatherNews v1.0\nMade by Amir")
                PickerCard()
            }
            .padding()
        }
        .navigationTitle("Settings")
    }
}

struct ToggleCard: View {
    let title: String
    @Binding var isOn: Bool
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Label(title, systemImage: icon)
                .foregroundColor(color)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
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
struct PickerCard: View {
    @AppStorage("temperatureUnit") private var unit = "Celsius"

    var body: some View {
        VStack(alignment: .leading) {
            Text("Temperature Unit")
                .font(.headline)
            Picker("Unit", selection: $unit) {
                Text("Celsius (°C)").tag("Celsius")
                Text("Fahrenheit (°F)").tag("Fahrenheit")
                Text("Kelvin (°K)").tag("Kelvin")
            }
            .pickerStyle(.segmented)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(radius: 1)
    }
}



#Preview {
    Settings()
}
