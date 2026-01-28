//
//  GameRepository.swift
//  Data
//
//  Created by 김동준 on 7/26/25
//

import Domain
import Foundation
import Util

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
    
    public func putTodayGameStatus(_ gameID: Int) async -> Result<OmokStoneStatus, NetworkError> {
        do {
            let endPoint = EndPoint<RemoteResponseModel<TodayGameStatusResponse>>.putTodayGameStatus(
                gameID: gameID,
                queryParameters: TodayGameStatusRequest(
                    date: Date.now.formattedString(format: DateFormatConstants.yearMonthDayRequestFormat)
                )
            )
            let response = try await apiService.call(endPoint)
            return .success(try GameMapper.toOmokStoneStatus(response.data))
        } catch {
            return .failure(ErrorMapper.toNetworkError(error))
        }
    }

    public func getAllGameInfoList(_ request: GameRoomInformationRequestModel) async -> Result<GameRoomInfo, NetworkError> {
        do {
            let queryParameters = AllGameInfoListRequest(
                joinable: request.joinable,
                category: request.categoryList?.compactMap { Int($0.code) }, // 서버에서 List형식으로 아직 바꿔주지 않음.
                search: request.search,
                pageNumber: request.pageNumber,
                pageSize: request.pageSize
            )
            
            let endPoint = EndPoint<RemoteResponseModel<GameParticipateInfoResponse>>.getAllGameInfoList(
                queryParameters: queryParameters
            )
            let response = try await apiService.call(endPoint)
            return .success(try GameMapper.toGameRoomInformation(response.data))
        } catch {
            return .failure(ErrorMapper.toNetworkError(error))
        }
    }
    
    public func postParticipateRoom(gameID: Int, password: String?) async -> Result<Bool, NetworkError> {
        do {
            let request = ParticipateRoomRequest(password: password)
            let endPoint = EndPoint<RemoteResponseModel<ParticipateRoomResponse>>.postParticipateRoom(
                gameID: gameID,
                request: request
            )
            let _ = try await apiService.call(endPoint)
            return .success(true)
        } catch let remoteError as RemoteNetworkError {
            switch remoteError {
            case .badRequest:
                return .success(false)
            default:
                return .failure(ErrorMapper.mapRemoteResponseError(remoteError))
            }
        } catch {
            return .failure(.unKnownError)
        }
    }
    
    public func getGameParticipants(gameID: Int) async -> Result<[GameParticipantInfo], NetworkError> {
        do {
            let endPoint = EndPoint<RemoteResponseModel<GameParticipantsResponse>>.getGameParticipants(gameID: gameID)
            let response = try await apiService.call(endPoint)
            return .success(try GameMapper.toGameParticipantInfoList(response.data))
        } catch {
            return .failure(ErrorMapper.toNetworkError(error))
        }
    }
    
    public func putGameHost(gameID: Int, userID: Int) async -> Result<Void, NetworkError> {
        do {
            let request = HostChangeRequest(userId: userID)
            let endPoint = EndPoint<RemoteResponseModel<HostChangeResponse>>.putGameHost(
                gameID: gameID,
                request: request
            )
            let _ = try await apiService.call(endPoint)
            return .success(())
        } catch {
            return .failure(ErrorMapper.toNetworkError(error))
        }
    }
    
    public func getGameDetailSetting(gameID: Int) async -> Result<GameDetailSettingConfiguration, NetworkError> {
        do {
            let endPoint = EndPoint<RemoteResponseModel<GameDetailSettingResponse>>.getGameDetailSetting(
                gameID: gameID
            )
            let response = try await apiService.call(endPoint)
            return .success(try GameMapper.toGameDetailSettingConfiguration(response.data))
        } catch {
            return .failure(ErrorMapper.toNetworkError(error))
        }
    }
    
    public func postKickUser(gameID: Int, userID: Int) async -> Result<Void, NetworkError> {
        do {
            let endPoint = EndPoint<RemoteResponseModel<KickUserResponse>>.postKickUser(
                gameID: gameID,
                userID: userID
            )
            let _ = try await apiService.call(endPoint)
            return .success(())
        } catch {
            return .failure(ErrorMapper.toNetworkError(error))
        }
    }
}
