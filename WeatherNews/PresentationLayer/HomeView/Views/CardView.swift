//
//  Card.swift
//  WeatherNews
//
//  Created by Macos on 06/01/2026.
//

import Foundation
import SwiftUI
struct CardView: View {
    let icon: Image
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 8) {
            icon
                .font(.system(size: 28))
                .foregroundColor(Color.init(hex: "#6f6f6f"))

            Text(title)
                .font(.headline)

            Text(subtitle)
                .font(.caption)
        }
        .frame(width: 120, height: 120)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.blue.opacity(0.3))
                .shadow(radius: 3)
        )
    }
}

