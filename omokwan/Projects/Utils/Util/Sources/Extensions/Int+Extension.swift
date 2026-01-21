//
//  Int+Extension.swift
//  Util
//
//  Created by 김동준 on 1/19/26
//

public extension Array where Element == Int {
    func toDayDescription(isSpaced: Bool) -> String {
        let dayTextMap: [Int: String] = [
            1: "월",
            2: "화",
            3: "수",
            4: "목",
            5: "금",
            6: "토",
            7: "일",
            8: "주중",
            9: "주말",
            10: "매일"
        ]
        
        let unique = Set(self)
        if unique == [10] || unique == [1,2,3,4,5,6,7] { return "매일" }
        if unique == [8] || unique == [1,2,3,4,5] { return "주중" }
        if unique == [9] || unique == [6,7] { return "주말" }

        let separator = isSpaced ? ", " : ","
        let texts = self
            .sorted()
            .compactMap { dayTextMap[$0] }

        return texts.joined(separator: separator)
    }
}
