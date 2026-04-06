//
//  KeyChainStorable.swift
//  Data
//
//  Created by 김동준 on 9/6/25
//

import Foundation

protocol KeyChainStorable {
    func toData() -> Data?
    static func fromData(_ data: Data) -> Self?
}

extension String: KeyChainStorable {
    func toData() -> Data? {
        return self.data(using: .utf8)
    }
    
    static func fromData(_ data: Data) -> String? {
        return String(data: data, encoding: .utf8)
    }
}

extension Bool: KeyChainStorable {
    func toData() -> Data? {
        let value = self ? "true" : "false"
        return value.data(using: .utf8)
    }
    
    static func fromData(_ data: Data) -> Bool? {
        guard let stringValue = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        switch stringValue.lowercased() {
        case "true":
            return true
        case "false":
            return false
        default:
            return nil
        }
    }
}

extension Int: KeyChainStorable {
    func toData() -> Data? {
        return String(self).data(using: .utf8)
    }
    
    static func fromData(_ data: Data) -> Int? {
        guard let stringValue = String(data: data, encoding: .utf8) else {
            return nil
        }
        return Int(stringValue)
    }
}
