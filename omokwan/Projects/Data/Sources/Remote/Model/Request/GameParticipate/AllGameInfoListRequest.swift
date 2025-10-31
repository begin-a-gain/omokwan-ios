//
//  AllGameInfoListRequest.swift
//  Data
//
//  Created by 김동준 on 10/25/25
//

struct AllGameInfoListRequest: Encodable {
    let joinable: Bool
    let category: [Int]?
    let search: String?
    let pageNumber: Int
    let pageSize: Int
    
    init(
        joinable: Bool,
        category: [Int]?,
        search: String?,
        pageNumber: Int,
        pageSize: Int
    ) {
        self.joinable = joinable
        self.category = category
        self.search = search
        self.pageNumber = pageNumber
        self.pageSize = pageSize
    }
}
