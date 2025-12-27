//
//  ApiService.swift
//  Data
//
//  Created by 김동준 on 9/15/24
//

import Foundation
import Domain
import Util

public final class ApiService {
    private let tokenProvider: TokenProvider
    
    public init(tokenProvider: TokenProvider) {
        self.tokenProvider = tokenProvider
    }
    
    func call<T: Decodable>(_ endPoint: EndPoint<T>, retryCount: Int = 1) async throws -> T {
        do {
            var logOutput: String = ""
            
            guard var url = URL(string: "http://\(BaseUrl.current)\(endPoint.path.value)") else {
                throw (RemoteNetworkError.requestURLNotExistError)
            }
            
            if let queryParameters = endPoint.queryParameters {
                let queryItems = try getQueryParameter(queryParameters)
                url.append(queryItems: queryItems)
            }
            
            var urlRequest = endPoint.makeURLRequest(
                url: url,
                accessToken: tokenProvider.getAccessToken()
            )
            
            logOutput += "📨 HTTP Headers    : \(String(describing: urlRequest.allHTTPHeaderFields))\n"
            
            if let body = endPoint.requestBody {
                guard let httpBody = try? JSONEncoder().encode(body) else {
                    throw RemoteNetworkError.bodyEncodingError
                }
                urlRequest.httpBody = httpBody
                logOutput += "📦 HTTP Body       : \(body)\n"
            }
            
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                throw RemoteNetworkError.responseError
            }
            
            logOutput += "🚀 Request URL     : \(url)\n"
            logOutput += "📥 HTTP Method     : \(endPoint.method)\n"
            logOutput += "📊 Status Code     : \(statusCode)\n"

            if let str = String(data: data, encoding: .utf8) {
                logOutput += "🧾 Response Body   : \(str)\n"
            }
            
            logOutput += "-----------------------------\n"
            OLogger.network.log(logOutput)
            
            guard let error = mapStatusCodeToRemoteNetworkError(statusCode) else {
                do {
                    if data.isEmpty {
                        if let emptyResponse = EmptyResponse() as? T {
                            return emptyResponse
                        } else {
                            throw RemoteNetworkError.responseDataNilError
                        }
                    }
                    let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                    checkCookieForRefreshToken(
                        path: endPoint.path.value,
                        response: response
                    )
                    return decodedResponse
                } catch let error as DecodingError {
                    throw RemoteNetworkError.decodingError(error)
                } catch {
                    throw RemoteNetworkError.unKnownError
                }
            }
            
            if case .unAuthorizationError = error {
                if retryCount >= 1 {
                    let retryCount = retryCount - 1
                    
                    let isRefreshTokenPublished = await requestNewAuthorizationFromRefreshToken(retryCount)
                    if isRefreshTokenPublished {
                        return try await self.call(endPoint, retryCount: retryCount)
                    } else {
                        throw RemoteNetworkError.unAuthorizationError
                    }
                }
                
                throw RemoteNetworkError.unAuthorizationError
            } else {
                throw error
            }
        } catch {
            try handleNetworkError(error)
        }
    }
}

private extension ApiService {
    func requestNewAuthorizationFromRefreshToken(_ retryCount: Int) async -> Bool {
        do {
            let savedRefreshToken = tokenProvider.getRefreshToken()
            let endPoint = EndPoint<RemoteResponseModel<RefreshTokenResponse>>.postRefreshToken(
                refreshToken: savedRefreshToken
            )
            let response = try await self.call(endPoint, retryCount: retryCount)
            let tokenPair = AuthMapper.toRefreshTokenResult(response.data)
            
            let accessToken = tokenPair.0
            let refreshToken = tokenPair.1
            
            if accessToken.isEmpty || refreshToken.isEmpty {
                return false
            }
            
            tokenProvider.setAccessToken(accessToken)
            tokenProvider.setRefreshToken(refreshToken)
            
            return true
        } catch {
            let message = """
            🛑 RefreshToken API 호출 시 알 수 없는 에러 발생
              - 타입: \(type(of: error))
              - 설명: \(error.localizedDescription)
            """
            OLogger.error.log(message)
            
            return false
        }
    }
}

// MARK: Query Parameter
private extension ApiService {
    func getQueryParameter(_ queryParameter: Encodable) throws -> [URLQueryItem] {
        do {
            guard let queryDictionary = try? queryParameter.toDictionary() else {
                throw RemoteNetworkError.queryParameterError
            }
            
            let queryItems = getURLQueryItems(queryDictionary: queryDictionary)
            
            return queryItems
        } catch {
            throw RemoteNetworkError.queryParameterError
        }
    }
    
    func getURLQueryItems(queryDictionary: [String: Any]) -> [URLQueryItem] {
        var queryList: [URLQueryItem] = []
        
        queryDictionary.forEach { key, value in
            if let array = value as? [Any] {
                array.forEach { element in
                    queryList.append(URLQueryItem(name: key, value: "\(element)"))
                }
            } else {
                queryList.append(URLQueryItem(name: key, value: "\(value)"))
            }
        }
        
        return queryList
    }
}

private extension ApiService {
    func checkCookieForRefreshToken(path: String, response: URLResponse) {
        let loginPath = EndPointPath.postSignIn("")
        
        if path.contains(loginPath.value) {
            guard let httpResponse = response as? HTTPURLResponse,
                  let headerFields = httpResponse.allHeaderFields as? [String: String],
                  let url = httpResponse.url else { return }
            
            let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: url)
            
            if let refreshCookie = cookies.first(where: { $0.name == "refresh_token" }) {
                let refreshToken = refreshCookie.value
                tokenProvider.setRefreshToken(refreshToken)
                OLogger.network.log("🚀 RefreshToken 발급 완료")
            }
        }
    }
}

private extension ApiService {
    func mapStatusCodeToRemoteNetworkError(_ code: Int) -> RemoteNetworkError? {
        switch code {
        case 200...299: return nil
        case 400: return .badRequest
        case 401: return .unAuthorizationError
        case 403: return .forbidden
        case 404: return .notFound
        case 400...499: return .clientError
        case 500: return .internalServerError
        case 503: return .serverMaintenanceError
        case 504: return .gatewayTimeout
        case 500...599: return .serverUnknownError
        default: return .unKnownError
        }
    }
}

private extension ApiService {
    func handleNetworkError(_ error: Error) throws -> Never {
        switch error {
        case let urlError as URLError:
            let message = """
            ❌ URLError 발생
              - 종류: \(urlError.code.rawValue) (\(urlError.code))
              - 설명: \(urlError.localizedDescription)
            """
            OLogger.error.log(message)
            
            switch urlError.code {
            case .timedOut, .networkConnectionLost:
                throw RemoteNetworkError.timeout
            default:
                throw RemoteNetworkError.urlError(urlError)
            }
        case let remoteNetworkError as RemoteNetworkError:
            let message = """
            🚨 RemoteNetworkError 발생
              - 에러 타입: \(remoteNetworkError)
              - 설명: \(remoteNetworkError.localizedDescription)
            """
            OLogger.error.log(message)
            throw remoteNetworkError
        default:
            let message = """
            🛑 알 수 없는 에러 발생 (RemoteNetworkError.unKnownError)
              - 타입: \(type(of: error))
              - 설명: \(error.localizedDescription)
            """
            OLogger.error.log(message)
            throw RemoteNetworkError.unKnownError
        }
    }
}
