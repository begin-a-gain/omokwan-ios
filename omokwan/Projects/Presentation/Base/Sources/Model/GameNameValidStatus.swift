//
//  GameNameValidStatus.swift
//  Base
//
//  Created by 김동준 on 9/23/25
//

public enum GameNameValidStatus {
    case empty
    case valid
    case inValidFormat
    
    public var errorMessage: String {
        switch self {
        case .empty, .valid:
            return ""
        case .inValidFormat:
            return "1~30글자 사이의 한글 혹은 영문만 입력해주세요."
        }
    }
}

