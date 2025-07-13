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
}
