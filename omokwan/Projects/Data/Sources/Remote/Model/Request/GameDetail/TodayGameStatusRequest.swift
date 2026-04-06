//
//  TodayGameStatusRequest.swift
//  Data
//
//  Created by 김동준 on 9/18/25
//

struct TodayGameStatusRequest: Encodable {
    let date: String
    
    init(date: String) {
        self.date = date
    }
}
