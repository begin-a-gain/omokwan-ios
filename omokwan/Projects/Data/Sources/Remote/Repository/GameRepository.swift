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
    
    public func getGameInfosFromDate(dateString: String) async -> Result<[MyGameModel], NetworkError> {
        do {
            let endPoint = EndPoint<RemoteResponseModel<[GameInfoResponse]>>.getGameInfoFromDate(
                queryParameters: GameInfoRequest(date: dateString)
            )
            let response = try await apiService.call(endPoint)
            return .success(try GameMapper.toMyGameModels(response.data))
        } catch {
            return .failure(ErrorMapper.toNetworkError(error))
        }
    }
}
