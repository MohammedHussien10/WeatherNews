

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    var body: some View {
        NavigationStack{
        WeatherDetailsView(viewModel: viewModel, fromFavorites: false)
            .task {
                await viewModel.loadCachedOrFetch(
                    latitude: viewModel.lat,
                    longitude: viewModel.long
                )
            }
        
    }
    .navigationBarTitleDisplayMode(.inline)
    .toolbarBackground(.clear, for: .tabBar)
    .toolbarBackground(.visible, for: .tabBar)


}
}


#Preview {
    HomeView()
}


