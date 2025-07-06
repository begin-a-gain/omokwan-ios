//
//  ApiService.swift
//  Data
//
//  Created by 김동준 on 9/15/24
//

import Foundation
import Domain

public struct ApiService {
    public init() {}
    
    func call<T: Decodable>(_ endPoint: EndPoint<T>) async throws -> T {
        do {
            guard var url = URL(string: "http://\(BaseUrl.current)\(endPoint.path)") else {
                throw (RemoteNetworkError.requestURLNotExistError)
            }
            
            if let queryParameters = endPoint.queryParameters {
                let queryItems = try getQueryParameter(queryParameters)
                url.append(queryItems: queryItems)
            }
            
            var urlRequest = endPoint.makeURLRequest(url: url)
            
            if let body = endPoint.requestBody {
                guard let httpBody = try? JSONEncoder().encode(body) else {
                    throw NetworkError.bodyEncodingError
                }
                urlRequest.httpBody = httpBody
            }
            
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                throw RemoteNetworkError.responseError
            }
            
            switch statusCode {
            case 200...299:
                do {
                    let decodedResponse = try JSONDecoder().decode(T.self, from: data)
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
            switch error.code {
            case .timedOut, .networkConnectionLost:
                throw RemoteNetworkError.timeout
            default:
                throw RemoteNetworkError.urlError(error)
            }
        } catch let error as RemoteNetworkError {
            throw error
        } catch {
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

// MARK: URLRequest
//private extension ApiService {
//    func makeURLRequest(url: URL, endPoint: EndPoint) -> URLRequest {
//        var urlRequest = URLRequest(url: url)
//        urlRequest.timeoutInterval = 30
//        urlRequest.httpMethod = endPoint.method.rawValue
//        if let headers = endPoint.headers {
//            headers.forEach { key, value in
//                urlRequest.setValue(value, forHTTPHeaderField: key)
//            }
//        }
//
//        return urlRequest
//    }
//    
//    func getHeaders() -> [String: String] {
//        let accessToken: String = ""
//        let tokenString: String = accessToken.isEmpty ? "" : "Bearer \(accessToken)"
//        return  [
//            "Authorization": tokenString,
//            "Content-Type": "application/json; charset=utf-8",
//            "Accept-Charset": "UTF-8"
//        ]
//    }
//}
