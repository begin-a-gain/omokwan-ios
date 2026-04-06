//
//  Date+Extension.swift
//  Util
//
//  Created by 김동준 on 11/30/24
//

import Foundation

extension Date {
    public func formattedString(format: String = DateFormatConstants.defaultFormat, timeZone: String = "Asia/Seoul") -> String {
        let dateFormmatter = DateFormatter()
        dateFormmatter.dateFormat = format
        dateFormmatter.timeZone = TimeZone(identifier: timeZone)
        let dateFormat = dateFormmatter.string(from: self)
        return dateFormat
    }
}

public extension Date {
    var seoulNow: Date {
        let now = self
        let timeZone = TimeZone(identifier: "Asia/Seoul") ?? .current
        
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone

        let components = calendar.dateComponents(in: timeZone, from: now)
        return calendar.date(from: components) ?? now
    }
    
    func addDay(_ value: Int) -> Date? {
        return Calendar.current.date(
            byAdding: .day,
            value: value,
            to: self
        )
    }
}
