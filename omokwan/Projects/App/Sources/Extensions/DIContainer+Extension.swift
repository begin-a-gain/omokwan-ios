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
        registerAccountDependency()
        registerSocialDependency()
        registerServerDependency()
        registerLocalStorageDependency()
    }
    
    private func registerKeyChainStorage() {
        container.register(KeyChainStorage.self) { _ in
            KeyChainStorage()
        }
    }
    
    private func registerApiServiceDependency() {
        container.register(ApiService.self) { resolver in
            let localRepositoryProtocol: LocalRepositoryProtocol = resolver.resolve()
            return ApiService(localRepositoryProtocol: localRepositoryProtocol)
        }
    }
    
    private func registerSocialService() {
        container.register(SocialService.self) { _ in
            SocialService()
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
    
    private func registerLocalStorageDependency() {
        container.register(LocalRepositoryProtocol.self) { resolver in
            let keyChainStorage: KeyChainStorage = resolver.resolve()
            return LocalRepository(keyChainStorage: keyChainStorage)
        }
    }
}
