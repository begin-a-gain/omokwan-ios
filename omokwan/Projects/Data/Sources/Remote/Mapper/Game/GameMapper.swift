//
//  GameMapper.swift
//  Data
//
//  Created by 김동준 on 7/26/25
//

import Domain
import Util

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
            needPreviousDatePaging: response.hasPrev ?? false,
            isTodayCompleted: response.isTodayMatchCompleted ?? false
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
    
    static func toGameParticipantInfoList(_ response: GameParticipantsResponse?) throws -> [GameParticipantInfo] {
        guard let response = response,
              let userInfo = response.userInfo else {
            throw RemoteNetworkError.responseDataNilError
        }
        
        return userInfo.map {
            GameParticipantInfo(
                userId: $0.userId ?? 0,
                nickname: $0.nickname ?? "",
                combo: $0.combo ?? 0,
                participantDays: $0.participantDays ?? 0,
                participantNumbers: $0.participantNumbers ?? 0
            )
        }
    }
    
    static func toGameDetailSettingConfiguration(_ response: GameDetailSettingResponse?) throws -> GameDetailSettingConfiguration {
        guard let response = response else {
            throw RemoteNetworkError.responseDataNilError
        }
        
        return GameDetailSettingConfiguration(
            title: response.name ?? "-",
            daysInProgress: response.ongoingDays ?? 0,
            code: response.matchCode ?? "-",
            dayDescription: response.repeatDayTypes
                .compactMap { $0 }
                .toDayDescription(isSpaced: true),
            maxNumberOfPlayers: response.maxParticipants ?? 0,
            categoryCode: response.category ?? "",
            password: response.password,
            isPublic: response.isPublic ?? false
        )
    }
    
    static func toGameUserPagingInfo(_ response: GameUserPagingResponse?) throws -> GameUserPagingInfo {
        guard let response = response else {
            throw RemoteNetworkError.responseDataNilError
        }

        return GameUserPagingInfo(
            users: (response.users ?? []).map { user in
                GameUserInfo(
                    userID: user.userId ?? 0,
                    nickname: user.nickname ?? ""
                )
            },
            nextCursor: response.nextCursor ?? "",
            hasNext: response.hasNext ?? false
        )
    }
}
