//
//  Favorites.swift
//  WeatherNews
//
//  Created by Macos on 21/10/2025.
//

import SwiftUI
struct Favorites: View {
    @EnvironmentObject var viewModel: FavoritesViewModel
    @State private var showMap = false
    var body: some View {
        NavigationStack {
            ZStack{
                RowOfFavoritesList().environmentObject(viewModel)
                
                FAB{
                    showMap = true
                }
  
            }.navigationTitle("favorites_title".localized)
                .task {
                    await viewModel.loadFavorites()
                }
                .navigationDestination(isPresented: $showMap) {
                    MapView(mode: .favorites) { ـ in
                        
                    }.environmentObject(viewModel)
                    
                }.overlay(alignment: .bottom) {
                    if viewModel.showToast {
                        ToastView(message: viewModel.toastMessage)
                            .padding(.bottom, 70)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .zIndex(100)
                    }
                }.onChange(of: viewModel.showToast) { show in
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
}
#Preview {
    Favorites()
}


