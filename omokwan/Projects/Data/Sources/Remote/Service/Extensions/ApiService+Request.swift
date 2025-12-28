//
//  ApiService+Request.swift
//  Data
//
//  Created by 김동준 on 12/28/25
//

import Foundation

extension ApiService {
    func makeRequest<T>(_ endPoint: EndPoint<T>) throws -> URLRequest {
        let url = try makeURL(endPoint)
        var request = endPoint.makeURLRequest(
            url: url,
            accessToken: tokenProvider.getAccessToken()
        )

        if let body = endPoint.requestBody {
            guard let httpBody = try? JSONEncoder().encode(body) else {
                throw RemoteNetworkError.bodyEncodingError
            }
            request.httpBody = httpBody
        }

        return request
    }

    func makeURL<T>(_ endPoint: EndPoint<T>) throws -> URL {
        guard var url = URL(
            string: "http://\(BaseUrl.current)\(endPoint.path.value)"
        ) else {
            throw RemoteNetworkError.requestURLNotExistError
        }

        if let queryParameters = endPoint.queryParameters {
            let queryItems = try getQueryParameter(queryParameters)
            url.append(queryItems: queryItems)
        }

        return url
    }
}

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
