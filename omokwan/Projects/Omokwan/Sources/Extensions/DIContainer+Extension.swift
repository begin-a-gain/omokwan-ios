//
//  DIContainer+Extension.swift
//  App
//
//  Created by 김동준 on 9/15/24
//

import DI
import Data
import Domain

extension DIContainer {
    func register() {
        registerKeyChainStorage()
        registerApiServiceDependency()
        registerSocialService()
        registerFirebaseService()
        registerAnalyticsService()
        registerAccountDependency()
        registerSocialDependency()
        registerServerDependency()
        registerGameDependency()
        registerLocalStorageDependency()
        registerNotificationDependency()
        registerFirebaseDependency()
        registerAnalyticsDependency()
    }
    
    private func registerKeyChainStorage() {
        let keyChainStorage = KeyChainStorage()
        
        container.register(KeyChainStorage.self) { _ in
            keyChainStorage
        }
        container.register(TokenProvider.self) { _ in
            keyChainStorage
        }
    }
    
    private func registerApiServiceDependency() {
        container.register(ApiService.self) { resolver in
            let tokenProvider: TokenProvider = resolver.resolve()
            return ApiService(tokenProvider: tokenProvider)
        }
    }
    
    private func registerSocialService() {
        container.register(SocialService.self) { _ in
            SocialService()
        }
    }
    
    private func registerFirebaseService() {
        container.register(FirebaseService.self) { _ in
            FirebaseService()
        }
    }

    private func registerAnalyticsService() {
        container.register(AnalyticsService.self) { _ in
            AnalyticsService()
        }
    }
    
    private func registerAccountDependency() {
        container.register(AccountRepositoryProtocol.self) { resolver in
            let apiService: ApiService = resolver.resolve()
            return AccountRepository(apiService: apiService)
        }
    }
    
    private func registerSocialDependency() {
        container.register(SocialRepositoryProtocol.self) { resolver in
            let socialService: SocialService = resolver.resolve()
            return SocialRepository(socialService: socialService)
        }
    }
    
    private func registerServerDependency() {
        container.register(ServerRepositoryProtocol.self) { resolver in
            let apiService: ApiService = resolver.resolve()
            return ServerRepository(apiService: apiService)
        }
    }
    
    private func registerGameDependency() {
        container.register(GameRepositoryProtocol.self) { resolver in
            let apiService: ApiService = resolver.resolve()
            return GameRepository(apiService: apiService)
        }
    }
    
    private func registerLocalStorageDependency() {
        container.register(LocalRepositoryProtocol.self) { resolver in
            let keyChainStorage: KeyChainStorage = resolver.resolve()
            return LocalRepository(keyChainStorage: keyChainStorage)
        }
    }
    
    private func registerNotificationDependency() {
        container.register(NotificationRepositoryProtocol.self) { resolver in
            let apiService: ApiService = resolver.resolve()
            return NotificationRepository(apiService: apiService)
        }
    }
    
    private func registerFirebaseDependency() {
        container.register(FirebaseRepositoryProtocol.self) { resolver in
            let firebaseService: FirebaseService = resolver.resolve()
            return FirebaseRepository(firebaseService: firebaseService)
        }
    }

    private func registerAnalyticsDependency() {
        container.register(AnalyticsRepositoryProtocol.self) { resolver in
            let analyticsService: AnalyticsService = resolver.resolve()
            return AnalyticsRepository(analyticsService: analyticsService)
        }
    }
}
