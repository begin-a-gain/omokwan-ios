//
//  GameUseCase.swift
//  Domain
//
//  Created by 김동준 on 7/26/25
//

import DI
import Dependencies

public struct GameUseCase {
    public let fetchGameInfosFromDate: (_ dateString: String, _ isToday: Bool) async -> Result<[MyGameModel], NetworkError>
    public let createGame: (_ configuration: MyGameAddConfiguration) async -> Result<Void, NetworkError>
    public let fetchGameCategories: () async -> Result<[GameCategory], NetworkError>
    public let fetchDetailInfoWithPaging: (_ gameID: Int, _ dateString: String, _ pageSize: Int) async -> Result<MyGameDetailInfo, NetworkError>
    public let fetchDetailUserInfo: (_ gameID: Int, _ userID: Int) async -> Result<DetailUserInfo, NetworkError>
    public let updateTodayGameStatus: (_ gameID: Int) async -> Result<OmokStoneStatus, NetworkError>
    public let participateRoom: (_ gameID: Int, _ password: String?) async -> Result<Bool, NetworkError>
    public let fetchAllGameInfoList: (_ request: GameRoomInformationRequestModel) async -> Result<GameRoomInfo, NetworkError>
    public let fetchGameParticipants: (_ gameID: Int) async -> Result<[GameParticipantInfo], NetworkError>
    public let updateGameHost: (_ gameID: Int, _ userID: Int) async -> Result<Void, NetworkError>
    public let fetchGameDetailSetting: (_ gameID: Int) async -> Result<GameDetailSettingConfiguration, NetworkError>
    public let kickOutUser: (_ gameID: Int, _ userID: Int) async -> Result<Void, NetworkError>
    public let exitGame: (_ gameID: Int) async -> Result<Void, NetworkError>
    public let fetchMyPageGameInfo: (_ userID: Int) async -> Result<MyPageGameInfo, NetworkError>
    public let updateGameDetailSetting: (_ gameID: Int, _ request: GameDetailSettingRequestDTO) async -> Result<Void, NetworkError>
    public let inviteUsers: (_ gameID: Int, _ userIDs: [Int]) async -> Result<Void, NetworkError>
}

extension GameUseCase: DependencyKey {
    public static var liveValue: GameUseCase = {
        let repository: GameRepositoryProtocol = DIContainer.shared.resolve()
        return GameUseCase(
            fetchGameInfosFromDate: { dateString, isToday in
                await repository.getGameInfosFromDate(
                    dateString: dateString,
                    isToday: isToday
                )
            },
            createGame: { configuration in
                await repository.postCreateGame(configuration)
            },
            fetchGameCategories: {
                await repository.getGameCategories()
            },
            fetchDetailInfoWithPaging: { gameID, dateString, pageSize in
                await repository.getDetailInfoWithPaging(
                    gameID: gameID,
                    dateString: dateString,
                    pageSize: pageSize
                )
            },
            fetchDetailUserInfo: { gameID, userID in
                await repository.getDetailUserInfo(
                    gameID: gameID,
                    userID: userID
                )
            },
            updateTodayGameStatus: { gameID in
                await repository.putTodayGameStatus(gameID)
            },
            participateRoom: { gameID, password in
                await repository.postParticipateRoom(
                    gameID: gameID,
                    password: password
                )
            },
            fetchAllGameInfoList: { request in
                await repository.getAllGameInfoList(request)
            },
            fetchGameParticipants: { gameID in
                await repository.getGameParticipants(gameID: gameID)
            },
            updateGameHost: { gameID, userID in
                await repository.putGameHost(
                    gameID: gameID,
                    userID: userID
                )
            },
            fetchGameDetailSetting: { gameID in
                await repository.getGameDetailSetting(gameID: gameID)
            },
            kickOutUser: { gameID, userID in
                await repository.postKickUser(
                    gameID: gameID,
                    userID: userID
                )
            },
            exitGame: { gameID in
                await repository.deleteGame(gameID: gameID)
            },
            fetchMyPageGameInfo: { userID in
                await repository.getMyPage(userID: userID)
            },
            updateGameDetailSetting: { gameID, request in
                await repository.putGameDetailSetting(
                    gameID: gameID,
                    request: request
                )
            },
            inviteUsers: { gameID, userIDs in
                await repository.postInviteUsers(
                    gameID: gameID,
                    userIDs: userIDs
                )
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
