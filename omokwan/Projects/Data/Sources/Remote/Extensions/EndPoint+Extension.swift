//
//  EndPoint+Extension.swift
//  Data
//
//  Created by 김동준 on 6/28/25
//

import Foundation

extension EndPoint {
    func makeURLRequest(url: URL) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = 30
        urlRequest.httpMethod = self.method.rawValue
        if let headers = self.headers {
            headers.forEach { key, value in
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        let accessToken: String = ""
        let tokenString: String = accessToken.isEmpty ? "" : "Bearer \(accessToken)"
        
        urlRequest.setValue(tokenString, forHTTPHeaderField: "Authorization")
        urlRequest.setValue("UTF-8", forHTTPHeaderField: "Accept-Charset")
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        return urlRequest
    }
}
