//
//  ApiService+Logger.swift
//  Data
//
//  Created by 김동준 on 12/28/25
//

import Foundation
import Util

extension ApiService {
    func logResponse(
        request: URLRequest,
        data: Data,
        response: URLResponse
    ) {
        var logger = NetworkLogging()
        
        logger.request(request: request)
        logger.bodyIfNeeded(request.httpBody)
        logger.response(data: data, response: response)
        
        logger.printLog()
    }
    
    func logRemoteNetworkError(
        _ error: Error,
        remoteError: RemoteNetworkError
    ) {
        let message: String

        switch error {
        case let urlError as URLError:
            message = """
            ❌ URLError 발생
              - 종류: \(urlError.code.rawValue) (\(urlError.code))
              - 설명: \(urlError.localizedDescription)
            """

        case let remoteError as RemoteNetworkError:
            message = """
            🚨 RemoteNetworkError 발생
              - 에러 타입: \(remoteError)
              - 설명: \(remoteError.localizedDescription)
            """

        default:
            message = """
            🛑 알 수 없는 에러 발생
              - 타입: \(type(of: error))
              - 설명: \(error.localizedDescription)
            """
        }

        OLogger.error.log(message)
    }
}
