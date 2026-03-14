//
//  NotificationRepository.swift
//  Data
//
//  Created by jumy on 3/14/26.
//

import Domain

public struct NotificationRepository: NotificationRepositoryProtocol {
    private let apiService: ApiService
    
    public init(apiService: ApiService) {
        self.apiService = apiService
    }
    
    public func getNotificationList(_ filter: NotificationFilter) async -> Result<[NotificationInfo], NetworkError> {
        do {
            let queryParameters = NotificationFilterRequest(filter: filter.name)
            let endPoint = EndPoint<RemoteResponseModel<NotificationListResponse>>.getNotificationList(queryParameters)
            let response = try await apiService.call(endPoint)
            return .success(try NotificationMapper.toNotificationInfoList(response.data))
        } catch {
            return .failure(ErrorMapper.toNetworkError(error))
        }
    }
    
    public func getNotificationBadgeStatus() async -> Result<NotificationBadgeStatus, NetworkError> {
        do {
            let endPoint = EndPoint<RemoteResponseModel<NotificationBadgeResponse>>.getNotificationBadgeStatus()
            let response = try await apiService.call(endPoint)
            return .success(try NotificationMapper.toNotificationBadgeStatus(response.data))
        } catch {
            return .failure(ErrorMapper.toNetworkError(error))
        }
    }
    
    public func patchNotificationRead(id: Int?) async -> Result<Void, NetworkError> {
        do {
            let request = NotificationReadRequest(notificationId: id)
            let endPoint = EndPoint<EmptyResponse>.patchNotificationRead(request: request)
            let _ = try await apiService.call(endPoint)
            return .success(())
        } catch {
            return .failure(ErrorMapper.toNetworkError(error))
        }
    }
}
