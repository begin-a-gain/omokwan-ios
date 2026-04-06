//
//  ApiService+Retry.swift
//  Data
//
//  Created by 김동준 on 12/28/25
//

import Foundation
import Util

extension ApiService {
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
