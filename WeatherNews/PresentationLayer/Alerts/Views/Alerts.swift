//
//  Alerts.swift
//  WeatherNews
//
//  Created by Macos on 21/10/2025.
//

import SwiftUI

struct Alerts: View {
    @EnvironmentObject var viewModel: AlertsViewModel
    
    @State private var alertDate = Date()
    @State private var showDatePicker = false
    @State private var showMap = false
    @State private var type: AlertType = .notification
    var body: some View {
        ZStack{
            RowOfAlertsList().environmentObject(viewModel)
            
            AddAlertView{
                showMap = true
            }
        }.task {
            await AlertManager.shared.requestPermission()
           
        }
.navigationTitle("Weather Alerts")
.task {
    await viewModel.loadAlerts()

    if viewModel.isCreatingFromHome {
        showDatePicker = true
    }
}
.navigationDestination(isPresented: $showMap) {
            MapView(mode: .alerts) { _ in 
                showDatePicker = true
                
            }
            
        }.sheet(isPresented: $showDatePicker) {
            VStack(spacing: 16) {

                Text(viewModel.cityOfAlert ?? "No location selected")
                    .font(.headline)

                DatePicker(
                    "Select alert time",
                    selection: $alertDate,
                    in: Date()...,
                    displayedComponents: [.date, .hourAndMinute]
                )

                .datePickerStyle(.graphical)

                Picker("Alert Type", selection: $type) {
                    ForEach(AlertType.allCases, id: \.self) {
                        Text($0.rawValue.capitalized)
                    }
                }

                Button("Confirm") {
                    if let lat = viewModel.pendingLat,
                       let long = viewModel.pendingLong {

                        let success = viewModel.addAlert(
                            city: viewModel.cityOfAlert,
                            lat: lat,
                            long: long,
                            dateOfAlert: alertDate,
                            type: type
                        )

                        if success {
                            showDatePicker = false
                        }
                    }
                }

                .disabled(viewModel.cityOfAlert == nil)
            }
            .padding()
            
            
            if viewModel.showToast {
                     ToastView(message: viewModel.toastMessage)
                         .padding(.bottom, 24)
                         .transition(.move(edge: .bottom).combined(with: .opacity))
                         .zIndex(10)
                 }
            
        }
        .onChange(of: viewModel.showToast) { show in
            if show {
                Task {
                    try? await Task.sleep(for: .seconds(2))
                    withAnimation {
                        viewModel.showToast = false
                    }
                }
            }
        }



        
    }
    
}


#Preview {
    Alerts()
}
