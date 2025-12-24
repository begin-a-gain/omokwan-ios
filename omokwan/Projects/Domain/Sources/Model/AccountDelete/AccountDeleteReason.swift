//
//  AccountDeleteReason.swift
//  Domain
//
//  Created by 김동준 on 12/24/25
//

public enum AccountDeleteReason: CaseIterable {
    case notFrequentlyUsed
    case missingFeatures
    case tooComplex
    case usingAnotherApp
    case other
    
    public var title: String {
        switch self {
        case .notFrequentlyUsed: "자주 사용하지 않아요."
        case .missingFeatures: "원하는 기능이 없어요."
        case .tooComplex: "쓰기가 복잡해요."
        case .usingAnotherApp: "다른 앱을 쓰고 있어요."
        case .other: "기타 (직접 입력)"
        }
    }
    
    public var code: String {
        switch self {
        case .notFrequentlyUsed: "NOT_FREQUENTLY_USED"
        case .missingFeatures: "MISSING_FEATURES"
        case .tooComplex: "TOO_COMPLEX"
        case .usingAnotherApp: "USING_ANOTHER_APP"
        case .other: "OTHER"
        }
    }
}
