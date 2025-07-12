//
//  RemoteResponseModel.swift
//  Data
//
//  Created by 김동준 on 7/12/25
//

struct RemoteResponseModel<T: Decodable>: Decodable {
    let code: Int?
    let status: String?
    let message: String?
    let data: T?
}
