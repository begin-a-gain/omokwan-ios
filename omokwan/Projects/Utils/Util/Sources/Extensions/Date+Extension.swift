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
    
    func dateForFirstDayOfMonth(nMonthsAgo: Int, timeZone: String = "Asia/Seoul") -> Date {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: timeZone) ?? .current
        let now = self

        guard let previousMonthDate = calendar.date(
            byAdding: .month,
            value: -nMonthsAgo,
            to: now
        ) else {
            return now
        }
        
        return calendar.date(from: calendar.dateComponents([.year, .month], from: previousMonthDate)) ?? now
    }
    
    func dateForLastDayOfMonth(nMonthsAfter: Int, timeZone: String = "Asia/Seoul") -> Date {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: timeZone) ?? .current
        let now = self

        guard let monthAfterNextDate = calendar.date(
            byAdding: .month,
            value: nMonthsAfter+1,
            to: now
        ) else {
            return now
        }
        
        let firstDayForMonth = calendar.date(
            from: calendar.dateComponents(
                [.year, .month],
                from: monthAfterNextDate
            )
        ) ?? now

        return calendar.date(byAdding: .day, value: -1, to: firstDayForMonth) ?? now
    }
    
    static func getRangeOfDates(from startDate: Date, to endDate: Date) -> [Date] {
        let oneDay: TimeInterval = 60 * 60 * 24
        
        return stride(
            from: startDate,
            through: endDate,
            by: oneDay
        ).map { $0 }
    }
    
    static func getMonthlyDateDictionary(
        from startDate: Date,
        to endDate: Date,
        timeZone: String = "Asia/Seoul",
        formatter: String = DateFormatConstants.calendarDayDateFormatter
    ) -> [String: [Date]] {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: timeZone) ?? .current
        
        var result: [String: [Date]] = [:]
        
        var currentDate = startDate
        while currentDate <= endDate {
            let key = currentDate.formattedString(format: formatter)
            result[key, default: []].append(currentDate)
            
            guard let nextDay = calendar.date(byAdding: .day, value: 1, to: currentDate) else {
                break
            }
            currentDate = nextDay
        }
        
        return result
    }
}
