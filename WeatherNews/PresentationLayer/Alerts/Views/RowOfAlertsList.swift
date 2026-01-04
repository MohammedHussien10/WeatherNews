//
//  RowOfAlertsList.swift
//  WeatherNews
//
//  Created by Macos on 31/12/2025.
//

import SwiftUI
struct RowOfAlertsList: View {
    @EnvironmentObject var viewModel:AlertsViewModel
 
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
                    
                    let sortedAlerts = viewModel.alerts.sorted {
                        $0.isActive && !$1.isActive
                    }
                    ForEach(sortedAlerts) { alert in
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text(alert.city)
                                Text(alert.type.rawValue.capitalized)
                                    .font(.caption)
                            }
                            
//                            Spacer()
//                            if alert.isActive {
//                                Button("Stop") {
//                                    viewModel.stopAlert(id: alert.id)
//                                }.tint(.red)
//                            }
                        }
                        
                        
                        
                    }.onDelete { indexSet in
                        for index in indexSet {
                            let id = sortedAlerts[index].id
                            Task{
                                await viewModel.deleteAlert(id: id)
                            }
                        }
                    }
                    
                }
            }
        }
    }
}
