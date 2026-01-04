//
//  RowOfAlertsList.swift
//  WeatherNews
//
//  Created by Macos on 31/12/2025.
//

import SwiftUI
struct RowOfAlertsList: View {
    @EnvironmentObject var viewModel:AlertsViewModel
    @State private var showDeleteAlert = false
    @State private var alertToDelete: WeatherAlert?

    var body: some View {
        Group{
            
            if viewModel.alerts.isEmpty {
                ContentUnavailableView(
                    "No Alerts",
                    systemImage: "bell",
                    description: Text("Tap + to add a weather alert")
                )
            } else {
                
                
                
                List {
                    
                    ForEach(viewModel.sortedAlerts) { alert in
                           HStack {
                               VStack(alignment: .leading) {
                                   Text(alert.city)
                                   Text(alert.type.rawValue.capitalized)
                                       .font(.caption)
                               }
                           }
                       } .onDelete { indexSet in
                           if let index = indexSet.first {
                               alertToDelete = viewModel.sortedAlerts[index]
                               showDeleteAlert = true
                           }
                       }


                    
                }
            }
        }.alert("Delete Alert", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let alert = alertToDelete {
                    Task {
                        await viewModel.deleteAlert(id: alert.id)
                        alertToDelete = nil
                    }
                }
            }

            Button("Cancel", role: .cancel) {
                alertToDelete = nil
            }
        } message: {
            Text("Delete alert for \(alertToDelete?.city ?? "this location")?")
        }

    }
}
