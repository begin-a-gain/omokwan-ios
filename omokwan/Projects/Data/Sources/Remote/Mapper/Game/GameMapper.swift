//
//  GameMapper.swift
//  Data
//
//  Created by 김동준 on 7/26/25
//

import Domain

struct GameMapper {
    static func toMyGameModels(_ gameInfoResponseList: [GameInfoResponse]?, _ isToday: Bool) throws -> [MyGameModel] {
        guard let gameInfoResponseList = gameInfoResponseList else {
            throw RemoteNetworkError.responseDataNilError
        }
        
        return gameInfoResponseList.map { gameInfo in
            let completeStatus: MyGameCompleteStatus
            if let isCompleted = gameInfo.completed {
                switch isCompleted {
                case true:
                    completeStatus = .complete
                case false:
                    completeStatus = isToday ? .inComplete : .inCompleteWithSkip
                }
            } else {
                completeStatus = .inComplete
            }
            
            return MyGameModel(
                gameID: gameInfo.matchId ?? -1,
                name: gameInfo.name ?? "-",
                onGoingDays: gameInfo.ongoingDays ?? 0,
                participants: gameInfo.participants ?? 0,
                maxParticipants: gameInfo.maxParticipants ?? 0,
                myGameCompleteStatus: completeStatus,
                isPrivateRoom: gameInfo.public == false
            )
        }
    }
    
    static func toGameCategory(_ gameCategoryResponse: [GameCategoryResponse]?) throws -> [GameCategory] {
        guard let gameCategoryResponse = gameCategoryResponse else {
            throw RemoteNetworkError.responseDataNilError
        }
        
        return gameCategoryResponse.map { gameCategory in
            GameCategory(
                code: gameCategory.code ?? "-1",
                category: gameCategory.category ?? "-",
                emoji: gameCategory.emoji?.unicodeEmoji ?? "-"
            )
        }
    }
    
    static func toMyGameDetailInfo(_ response: GameDetailPagingResponse?) throws -> MyGameDetailInfo {
        guard let response = response else {
            throw RemoteNetworkError.responseDataNilError
        }
        
        return MyGameDetailInfo(
            users: response.users?.map {
                $0.toDomain()
            } ?? [],
            dates: response.dates?.map {
                $0.toDomain()
            } ?? [],
            previousDateCursor: response.prevCursor ?? "",
            nextDateCursor: response.nextCursor ?? "",
            needNextDatePaging: response.hasNext ?? false,
            needPreviousDatePaging: response.hasPrev ?? false
        )
    }
    
    static func toDetailUserInfo(_ response: DetailUserInfoResponse?) throws -> DetailUserInfo {
        guard let response = response else {
            throw RemoteNetworkError.responseDataNilError
        }

        return DetailUserInfo(
            nickname: response.nickName ?? "",
            combo: response.combo ?? 0,
            stones: response.participantNumbers ?? 0,
            participantDays: response.participantDays ?? 0,
            isHost: response.isHost ?? false
        )
    }
    
    static func toOmokStoneStatus(_ response: TodayGameStatusResponse?) throws -> OmokStoneStatus {
        guard let response = response else {
            throw RemoteNetworkError.responseDataNilError
        }
        
        return (response.completed ?? false) ? .completed : .inCompleted
    }
    
    static func toGameRoomInformation(_ response: GameParticipateInfoResponse?) throws -> GameRoomInfo {
        guard let response = response,
              let matchList = response.matchList else {
            throw RemoteNetworkError.responseDataNilError
        }
        
        let gameRoomInformation = matchList.map {
            GameRoomInformation(
                id: $0.matchId ?? 0,
                categoryId: $0.categoryId,
                name: $0.name ?? "",
                hostName: $0.hostName ?? "",
                ongoingDays: $0.ongoingDays ?? 0,
                participants: $0.participants ?? 0,
                maxParticipants: $0.maxParticipants ?? 0,
                joinStatus: RoomJoinStatus(rawValue: $0.joinable ?? "") ?? .impossible,
                isPublic: $0.public ?? false
            )
        }
        
        return GameRoomInfo(
            gameRoomInformation: gameRoomInformation,
            hasNext: response.hasNext ?? false
        )
    }
}
