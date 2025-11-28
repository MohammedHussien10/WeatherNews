//
//  FAB.swift
//  WeatherNews
//
//  Created by Macos on 21/11/2025.
//

import SwiftUI

struct FAB: View {
    var action: () -> Void
    var body: some View {
      
        
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        
                        Button {
                            action()
                        } label: {
                            Image(systemName: "heart.fill")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .clipShape(Circle())
                                .shadow(radius: 6)
                            
                        }
                        .padding()
                    }
                }
            }
        }
}

#Preview {
    FAB(action: {})
}
