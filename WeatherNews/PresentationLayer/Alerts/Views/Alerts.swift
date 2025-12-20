//
//  Alerts.swift
//  WeatherNews
//
//  Created by Macos on 21/10/2025.
//

import SwiftUI

struct Alerts: View {
    @StateObject var viewModel = AlertsViewModel()
    @State private var showAddAlert = false
    var body: some View {
        List {
            ForEach(viewModel.alerts) { alert in
                HStack {
                    VStack(alignment: .leading) {
                                          Text(alert.city)
                                          Text(alert.type.rawValue.capitalized)
                                              .font(.caption)
                                      }
                    
                    Spacer()
                    if alert.isActive {
                        Button("Stop") {
                            viewModel.stopAlert(id: alert.id)
                        }.foregroundColor(.red)
                    }
                }
                
                
                
            }
        }.navigationTitle("Weather Alerts")
            .toolbar {
                      Button {
                          showAddAlert = true
                      } label: {
                          Image(systemName: "plus")
                      }
                  } .sheet(isPresented: $showAddAlert) {
                      AddAlertView { city, start, end, type in
                          viewModel.addAlert(
                              city: city,
                              start: start,
                              end: end,
                              type: type
                          )
                      }
                  }
                  .task {
                      await AlertManager.shared.requestPermission()
                  }
    }
    
    
}

#Preview {
    Alerts()
}
