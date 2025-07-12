//
//  ServerRepository.swift
//  Data
//
//  Created by 김동준 on 6/28/25
//

import Domain

public struct ServerRepository: ServerRepositoryProtocol {
    private let apiService: ApiService
    
    public init(apiService: ApiService) {
        self.apiService = apiService
    }
    
    public func healthCheck() async -> Result<Bool, NetworkError> {
        do {
            let endPoint = EndPoint<RemoteResponseModel<Bool>>.getHealthCheck()
            let result = try await apiService.call(endPoint)
            guard let value = result.data else { return .failure(.responseError) }

            // TODO: splash 작업할 때, return 값 변경 예정
            return .success(true)
        } catch {
            return .success(false)
        }
    }
}
