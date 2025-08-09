//
//  GameUseCase.swift
//  Domain
//
//  Created by 김동준 on 7/26/25
//

import DI
import Dependencies

public struct GameUseCase {
    public let fetchGameInfosFromDate: (_ dateString: String) async -> Result<[MyGameModel], NetworkError>
    public let createGame: (_ configuration: MyGameAddConfiguration) async -> Result<Void, NetworkError>
}

extension GameUseCase: DependencyKey {
    public static var liveValue: GameUseCase = {
        let repository: GameRepositoryProtocol = DIContainer.shared.resolve()
        return GameUseCase(
            fetchGameInfosFromDate: { dateString in
                await repository.getGameInfosFromDate(dateString: dateString)
            },
            createGame: { configuration in
                await repository.postCreateGame(configuration)
            }
        )
    }()
}

extension DependencyValues {
    public var gameUseCase: GameUseCase {
        get { self[GameUseCase.self] }
        set { self[GameUseCase.self] = newValue }
    }
}
