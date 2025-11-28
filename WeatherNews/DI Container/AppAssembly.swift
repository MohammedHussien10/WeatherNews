//
//  AppAssembly.swift
//  WeatherNews
//
//  Created by Macos on 17/11/2025.
//

import Foundation
import Swinject
final class AppAssembly {
    static let container: Container = {
        let container = Container()

        container.register(RemoteDataSource.self) { _ in RemoteDataSourceImpl() }
        container.register(Repository.self) { r in RepositoryImpl(remoteDataSource: r.resolve(RemoteDataSource.self)!) }
        container.register(UseCaseWeather.self) { r in UseCaseWeatherImpl(repo: r.resolve(Repository.self)!) }
        container.register(HomeViewModel.self) { r in
            
            HomeViewModel(getWeatherUseCase: r.resolve(UseCaseWeather.self)!)
        }.inObjectScope(.container)

        return container
    }()
}
