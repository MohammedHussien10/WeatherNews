
import SwiftUI

struct FAB: View {
    var action: () -> Void


    var body: some View {
        VStack {
            Spacer()
                HStack {
                    Spacer()
                    Button(action: action) {
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

#Preview {
    FAB(action: {})
}

