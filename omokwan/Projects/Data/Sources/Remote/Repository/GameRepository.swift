//
//  GameRepository.swift
//  Data
//
//  Created by 김동준 on 7/26/25
//

import Domain

public struct GameRepository: GameRepositoryProtocol {
    private let apiService: ApiService
    
    public init(apiService: ApiService) {
        self.apiService = apiService
    }
    
    public func getGameInfosFromDate(dateString: String, isToday: Bool) async -> Result<[MyGameModel], NetworkError> {
        do {
            let endPoint = EndPoint<RemoteResponseModel<[GameInfoResponse]>>.getGameInfoFromDate(
                queryParameters: GameInfoRequest(date: dateString)
            )
            let response = try await apiService.call(endPoint)
            return .success(try GameMapper.toMyGameModels(response.data, isToday))
        } catch {
            return .failure(ErrorMapper.toNetworkError(error))
        }
    }
    
    public func postCreateGame(_ configuration: MyGameAddConfiguration) async -> Result<Void, NetworkError> {
        do {
            let requestBody = CreateGameRequest(
                name: configuration.name,
                dayType: configuration.dayType,
                maxParticipants: configuration.maxParticipants,
                categoryCode: configuration.categoryCode,
                password: configuration.password,
                isPublic: configuration.isPublic
            )
            
            let endPoint = EndPoint<RemoteResponseModel<CreateGameResponse>>.postCreateGame(requestBody: requestBody)
            let _ = try await apiService.call(endPoint)
            return .success(())
        } catch {
            return .failure(ErrorMapper.toNetworkError(error))
        }
    }
    
    public func getGameCategories() async -> Result<[GameCategory], NetworkError> {
        do {
            let endPoint = EndPoint<RemoteResponseModel<[GameCategoryResponse]>>.getGameCategories()
            let response = try await apiService.call(endPoint)
            return .success(try GameMapper.toGameCategory(response.data))
        } catch {
            return .failure(ErrorMapper.toNetworkError(error))
        }
    }
    
    public func getDetailInfoWithPaging(
        gameID: Int,
        dateString: String,
        pageSize: Int
    ) async -> Result<MyGameDetailInfo, NetworkError> {
        do {
            let endPoint = EndPoint<RemoteResponseModel<GameDetailPagingResponse>>.getDetailInfoWithPaging(
                gameID: gameID,
                request: GameDetailPagingRequest(
                    date: dateString,
                    size: pageSize
                )
            )
            
            let response = try await apiService.call(endPoint)
            return .success(try GameMapper.toMyGameDetailInfo(response.data))
        } catch {
            return .failure(ErrorMapper.toNetworkError(error))
        }
    }
    
    public func getDetailUserInfo(gameID: Int, userID: Int) async -> Result<DetailUserInfo, NetworkError> {
        do {
            let endPoint = EndPoint<RemoteResponseModel<DetailUserInfoResponse>>.getDetailUserInfo(
                gameID: gameID,
                userID: userID
            )
            
            let response = try await apiService.call(endPoint)
            return .success(try GameMapper.toDetailUserInfo(response.data))
        } catch {
            return .failure(ErrorMapper.toNetworkError(error))
        }
    }
}
