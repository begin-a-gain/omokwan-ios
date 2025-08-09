//
//  GameMapper.swift
//  Data
//
//  Created by 김동준 on 7/26/25
//

import Domain

struct GameMapper {
    static func toMyGameModels(_ gameInfoResponseList: [GameInfoResponse]?) throws -> [MyGameModel] {
        guard let gameInfoResponseList = gameInfoResponseList else {
            throw RemoteNetworkError.responseDataNilError
        }
        
        return gameInfoResponseList.map { gameInfo in
            // TODO: 논의 후 이 부분 수정 필요
            let completeStatus: MyGameCompleteStatus
            if let isCompleted = gameInfo.completed {
                completeStatus = isCompleted ? .complete : .inComplete
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
                isPrivateRoom: gameInfo.public ?? false
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
                category: gameCategory.category ?? "-"
            )
        }
    }
}
