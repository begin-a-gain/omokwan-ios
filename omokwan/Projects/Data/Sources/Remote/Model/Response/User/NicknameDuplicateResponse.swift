//
//  NicknameDuplicateResponse.swift
//  Data
//
//  Created by 김동준 on 11/5/25
//

struct NicknameDuplicateResponse: Decodable {
    let isValid: Bool?
    let isDuplicated: Bool?
}
