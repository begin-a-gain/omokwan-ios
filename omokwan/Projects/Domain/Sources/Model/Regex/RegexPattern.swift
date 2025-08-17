//
//  RegexPattern.swift
//  Domain
//
//  Created by 김동준 on 7/13/25
//

public enum RegexPattern {
    case nickname
    case gameName
    
    public var regex: String {
        switch self {
        case .nickname:
            return #"^[가-힣a-zA-Z0-9]{2,10}$"#
        case .gameName:
            return #"^[가-힣a-zA-Z0-9]{1,30}$"#
        }
    }
}
