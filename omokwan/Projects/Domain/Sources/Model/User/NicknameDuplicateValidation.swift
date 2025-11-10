//
//  NicknameDuplicateValidation.swift
//  Domain
//
//  Created by 김동준 on 11/5/25
//

public struct NicknameDuplicateValidation: Equatable {
    public var isValid: Bool
    public var isDuplicated: Bool
    
    public init(
        isValid: Bool,
        isDuplicated: Bool
    ) {
        self.isValid = isValid
        self.isDuplicated = isDuplicated
    }
}
