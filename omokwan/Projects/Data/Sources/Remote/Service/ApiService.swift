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
    
    func call<T: Decodable>(_ endPoint: EndPoint<T>) async throws -> T {
        do {
            var logOutput: String = ""
            
            guard var url = URL(string: "http://\(BaseUrl.current)\(endPoint.path)") else {
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
            
            switch statusCode {
            case 200...299:
                do {
                    let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                    checkCookieForRefreshToken(
                        path: endPoint.path,
                        response: response
                    )
                    return decodedResponse
                } catch let error as DecodingError {
                    throw RemoteNetworkError.decodingError(error)
                } catch {
                    throw RemoteNetworkError.unKnownError
                }
            case 401:
                throw RemoteNetworkError.unAuthorizationError
            case 403:
                throw RemoteNetworkError.forbidden
            case 404:
                throw RemoteNetworkError.notFound
            case 400:
                throw RemoteNetworkError.badRequest
            case 400...499:
                throw RemoteNetworkError.clientError
            case 503:
                throw RemoteNetworkError.serverMaintenanceError
            case 504:
                throw RemoteNetworkError.gatewayTimeout
            case 500:
                throw RemoteNetworkError.internalServerError
            case 500...599:
                throw RemoteNetworkError.serverUnknownError
            default:
                throw RemoteNetworkError.unKnownError
            }
        } catch let error as URLError {
            let message = """
            ❌ URLError 발생
              - 종류: \(error.code.rawValue) (\(error.code))
              - 설명: \(error.localizedDescription)
            """
            OLogger.error.log(message)
            
            switch error.code {
            case .timedOut, .networkConnectionLost:
                throw RemoteNetworkError.timeout
            default:
                throw RemoteNetworkError.urlError(error)
            }
        } catch let error as RemoteNetworkError {
            let message = """
            🚨 RemoteNetworkError 발생
              - 에러 타입: \(error)
              - 설명: \(error.localizedDescription)
            """
            OLogger.error.log(message)
            throw error
        } catch {
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
            queryList.append(URLQueryItem(name: key, value: "\(value)"))
        }
        
        return queryList
    }
}

private extension ApiService {
    func checkCookieForRefreshToken(path: String, response: URLResponse) {
        if path.contains("/auth/login/") {
            guard let httpResponse = response as? HTTPURLResponse,
                  let headerFields = httpResponse.allHeaderFields as? [String: String],
                  let url = httpResponse.url else { return }
            
            let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: url)

            if let refreshCookie = cookies.first(where: { $0.name == "refresh_token" }) {
                let refreshToken = refreshCookie.value
                tokenProvider.setRefreshToken(refreshToken)
            }
        }
    }
}
