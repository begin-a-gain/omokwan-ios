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
        registerApiService()
        registerSocialService()
        registerAccountDependency()
        registerSocialDependency()
        registerServerDependency() // for ServerUsecase
    }
    
    private func registerApiService() {
        container.register(ApiService.self) { _ in
            ApiService()
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
    }}
