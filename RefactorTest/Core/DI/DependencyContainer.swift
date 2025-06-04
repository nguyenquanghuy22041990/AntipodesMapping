import Foundation
import Swinject

final class DependencyContainer {
    static let shared = DependencyContainer()
    
    private let container: Container
    
    private init() {
        container = Container()
        registerDependencies()
    }
    
    private func registerDependencies() {
        // Services
        container.register(LocationServiceProtocol.self) { _ in
            W3WLocationService(apiKey: Configuration.w3wApiKey)
        }.inObjectScope(.container)
        
        // UseCases
        container.register(GetLocationWordsUseCaseProtocol.self) { resolver in
            guard let locationService = resolver.resolve(LocationServiceProtocol.self) else {
                fatalError("Failed to resolve LocationServiceProtocol")
            }
            return GetLocationWordsUseCase(locationService: locationService)
        }.inObjectScope(.transient)
        
        // ViewModels
        container.register(AntipodesMapViewModel.self) { resolver in
            guard let useCase = resolver.resolve(GetLocationWordsUseCaseProtocol.self) else {
                fatalError("Failed to resolve GetLocationWordsUseCaseProtocol")
            }
            return AntipodesMapViewModel(getLocationWordsUseCase: useCase)
        }.inObjectScope(.transient)
    }
    
    func resolve<T>(_ type: T.Type) -> T? {
        container.resolve(type)
    }
}
