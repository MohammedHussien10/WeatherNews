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

    
    
