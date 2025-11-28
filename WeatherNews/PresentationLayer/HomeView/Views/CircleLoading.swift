//
//  DotsLoading.swift
//  WeatherNews
//
//  Created by Macos on 25/11/2025.
//

import Foundation
import SwiftUI
struct DotsLoading: View {
    @State private var rotate = false
      
      var body: some View {
          Circle()
              .trim(from: 0, to: 0.7)
              .stroke(Color.blue, lineWidth: 6)
              .frame(width: 60, height: 60)
              .rotationEffect(.degrees(rotate ? 360 : 0))
              .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: rotate)
              .onAppear { rotate = true }
      }
}
