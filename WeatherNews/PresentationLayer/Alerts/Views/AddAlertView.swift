//
//  AddAlertView.swift
//  WeatherNews
//
//  Created by Macos on 16/12/2025.
//

import SwiftUI

struct AddAlertView: View {
    var onSave: (String, Date, Date, AlertType) -> Void
    @State private var city = ""
    @State private var startDate = Date()
    @State private var endDate = Date().addingTimeInterval(3600)
    @State private var type: AlertType = .notification
    var body: some View {
        NavigationStack {
            Form {
                TextField("City", text: $city)
                
                DatePicker("Start", selection: $startDate)
                DatePicker("End", selection: $endDate)
                
                Picker("Alert Type", selection: $type) {
                    ForEach(AlertType.allCases, id: \.self) {
                        Text($0.rawValue.capitalized)
                    }
                }
                
                
            } .navigationTitle("Add Alert")
                .toolbar {
                    Button("Save") {
                        onSave(city, startDate, endDate, type)
                    }
                }
            
            
        }
    }
}
//#Preview {
//    AddAlertView()
//}
