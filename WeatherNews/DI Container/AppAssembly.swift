
import Foundation
import Swinject
final class AppAssembly {

    static let container: Container = {
        let container = Container()

        container.register(RemoteDataSource.self) { _ in
            RemoteDataSourceImpl()
        }

        container.register(LocalDataSource.self) { _ in
            LocalDataSourceImpl()
        }

        container.register(Repository.self) { r in

            guard let remote = r.resolve(RemoteDataSource.self) else {
                fatalError("RemoteDataSource not registered")
            }

            guard let local = r.resolve(LocalDataSource.self) else {
                fatalError("LocalDataSource not registered")
            }

            return RepositoryImpl(
                remoteDataSource: remote,
                localDataSource: local
            )
        }

        container.register(UseCaseWeather.self) { r in

            guard let repo = r.resolve(Repository.self) else {
                fatalError("Repository not registered")
            }

            return UseCaseWeatherImpl(repo: repo)
        }

        container.register(HomeViewModel.self) { r in

            guard let useCase = r.resolve(UseCaseWeather.self) else {
                fatalError("UseCaseWeather not registered")
            }

            return HomeViewModel(getWeatherUseCase: useCase)

        }.inObjectScope(.container)

        container.register(FavoritesViewModel.self) { r in

            guard let useCase = r.resolve(UseCaseWeather.self) else {
                fatalError("UseCaseWeather not registered for FavoritesViewModel")
            }

            return FavoritesViewModel(getWeatherUseCase: useCase)

        }.inObjectScope(.container)
        
        
        container.register(AlertsViewModel.self) { r in


            return AlertsViewModel()

        }.inObjectScope(.container)

        return container
    }()
}
