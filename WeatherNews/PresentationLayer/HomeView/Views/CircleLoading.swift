//
//  DotsLoading.swift
//  WeatherNews
//
//  Created by Macos on 25/11/2025.
//

import Foundation
import SwiftUI
struct CircleLoading: View {
    
    var body: some View {
        ZStack {
            Color.clear
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .tint(.white)
                    .scaleEffect(1.4)
                
                Text("Loading...")
                    .foregroundColor(.white)
                    .font(.headline)
            }
            .padding(30)
            .background(Color.black.opacity(0.6))
            .cornerRadius(16)
        }
        .transition(.opacity)
    }
}
