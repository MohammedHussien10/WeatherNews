
import SwiftUI
import Lottie
import Combine
struct SplashView: View {
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            WeatherContainer()
        } else {
            ZStack {
                LottieView(animationName: "Weather_News")
                    .frame(width: 200, height: 200)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}
