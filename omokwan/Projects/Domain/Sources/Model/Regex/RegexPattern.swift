//
//  RegexPattern.swift
//  Domain
//
//  Created by 김동준 on 7/13/25
//

public enum RegexPattern {
    case nickname
    case gameTitle
    
    public var regex: String {
        switch self {
        case .nickname:
            return #"^[가-힣a-zA-Z0-9]{2,10}$"#
        case .gameTitle:
            return #"^(?=.{1,30}$)[가-힣a-zA-Z0-9\s]+$"#
        }
    }
}
