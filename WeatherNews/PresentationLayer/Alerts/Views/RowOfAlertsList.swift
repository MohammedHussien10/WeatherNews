

import SwiftUI
struct RowOfAlertsList: View {
    @EnvironmentObject var viewModel:AlertsViewModel
    @State private var showDeleteAlert = false
    @State private var alertToDelete: WeatherAlert?

    var body: some View {
        Group{
            
            if viewModel.alerts.isEmpty {
                ContentUnavailableView(
                     "no_alerts".localized,
                     systemImage: "bell",
                     description:
                        Text("tap".localized)
                         + Text(Image(systemName: "bell"))
                     + Text(" to_add_alert".localized)
                 )
            } else {
                
                
                
                List {
                    
                    ForEach(viewModel.sortedAlerts) { alert in
                           HStack {
                               VStack(alignment: .leading) {
                                   Text(alert.city)
                                   Text(alert.type.rawValue.capitalized).foregroundColor(.blue)
                                  
                                   Text(alert.date.formatted(
                                       date: .abbreviated,
                                       time: .shortened
                                   ))
                                   .font(.subheadline)
                                   .foregroundColor(.gray)
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
        }.alert("delete_alert_title".localized, isPresented: $showDeleteAlert) {
            Button("delete".localized, role: .destructive) {
                if let alert = alertToDelete {
                    Task {
                        await viewModel.deleteAlert(id: alert.id)
                        alertToDelete = nil
                    }
                }
            }

            Button("cancel".localized, role: .cancel) {
                alertToDelete = nil
            }
        } message: {
            Text(
                   String(
                       format: "delete_alert_message".localized,
                       alertToDelete?.city ?? "unknown".localized
                   )
               )
        }

    }
}
