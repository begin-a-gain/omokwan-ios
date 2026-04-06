//
//  MyGameAddModel.swift
//  Domain
//
//  Created by 김동준 on 12/1/24
//

public enum MyGameAddRepeatDayType: String, CaseIterable {
    case weekday = "주중"
    case weekend = "주말"
    case everyday = "매일"
    case directSelection = "직접선택"
    
    public var code: Int {
        switch self {
        case .weekday: 8
        case .weekend: 9
        case .everyday: 10
        case .directSelection: 0
        }
    }
}

public enum MyGameAddDirectSelectionDayType: String, CaseIterable {
    case sun = "일"
    case mon = "월"
    case tue = "화"
    case wed = "수"
    case thu = "목"
    case fri = "금"
    case sat = "토"
    
    public var code: Int {
        switch self {
        case .sun: 7
        case .mon: 1
        case .tue: 2
        case .wed: 3
        case .thu: 4
        case .fri: 5
        case .sat: 6
        }
    }
}
