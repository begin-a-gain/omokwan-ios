//
//  GameDetailPagingRequest.swift
//  Data
//
//  Created by 김동준 on 9/7/25
//

struct GameDetailPagingRequest: Encodable {
    let date: String
    let size: Int
    
    init(date: String, size: Int) {
        self.date = date
        self.size = size
    }
}
