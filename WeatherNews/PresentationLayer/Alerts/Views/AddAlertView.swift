//
//  AddAlertView.swift
//  WeatherNews
//
//  Created by Macos on 16/12/2025.
//

import SwiftUI

struct AddAlertView: View {
    
    var action: () -> Void

    var body: some View {
        VStack {
            Spacer()
                HStack {
                    Spacer()
                    Button(action: action) {
                                   Image(systemName: "bell.fill")
                                       .font(.title)
                                       .foregroundColor(.white)
                                       .padding()
                                       .background(Color.green)
                                       .clipShape(Circle())
                                       .shadow(radius: 6)
                               }
                               .padding()
                    }
                }
            }
}

    
    
////    @Environment(\.dismiss) private var dismiss
////
////    var onSave: (String, Date, Date, AlertType) -> Void
////
////    @State private var city = ""
////    @State private var startDate = Date()
////    @State private var endDate = Date().addingTimeInterval(3600)
////    @State private var type: AlertType = .notification
////
////    var isValid: Bool {
////        !city.trimmingCharacters(in: .whitespaces).isEmpty &&
////        endDate > startDate
////    }
//
//    var body: some View {
//        NavigationStack {
//            Form {
//                TextField("City", text: $city)
//
//                DatePicker("Start", selection: $startDate)
//                DatePicker("End", selection: $endDate)
//
//                Picker("Alert Type", selection: $type) {
//                    ForEach(AlertType.allCases, id: \.self) {
//                        Text($0.rawValue.capitalized)
//                    }
//                }
//
//                if !isValid {
//                    Text("Please enter a valid city and date range")
//                        .font(.caption)
//                        .foregroundColor(.red)
//                }
//            }
//            .navigationTitle("Add Alert")
//            .toolbar {
//                ToolbarItem(placement: .confirmationAction) {
//                    Button("Save") {
//                        onSave(city, startDate, endDate, type)
//                        dismiss()
//                    }
//                    .disabled(!isValid)
//                }
//
//                ToolbarItem(placement: .cancellationAction) {
//                    Button("Cancel") {
//                        dismiss()
//                    }
//                }
//            }
//        }
//    }


//#Preview {
//    AddAlertView()
//}
