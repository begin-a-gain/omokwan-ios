//
//  HostChangeRequest.swift
//  Data
//
//  Created by 김동준 on 12/24/25
//

struct HostChangeRequest: Encodable {
    let userId: Int
    
    init(userId: Int) {
        self.userId = userId
    }
}
