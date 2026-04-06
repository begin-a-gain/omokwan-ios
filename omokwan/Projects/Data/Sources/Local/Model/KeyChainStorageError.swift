//
//  KeyChainStorageError.swift
//  Data
//
//  Created by 김동준 on 7/13/25
//

import Foundation

enum KeyChainStorageError: Error {
    case unExpectedStatus(OSStatus)
    case dataConversionFailed
    case noMatchKeyError
    
    var descrption: String {
        switch self {
        case .dataConversionFailed:
            """
            🛑 KeyChainStorageError: Data conversion failed
            """
        case .noMatchKeyError:
            """
            🛑 KeyChainStorageError: No Match Key Error
            """
        case .unExpectedStatus(let status):
            """
            🛑 KeyChainStorageError: UnExpectedStatus
              - 타입: \(type(of: status))
              - 설명: \(status.description)
            """
        }
    }
}
