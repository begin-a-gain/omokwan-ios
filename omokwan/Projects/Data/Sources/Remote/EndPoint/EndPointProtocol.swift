//
//  EndPointProtocol.swift
//  Data
//
//  Created by 김동준 on 6/9/25
//

protocol EndPointProtocol {
    var path: String { get }
    var method: HttpMethod { get }
    var headers: [String: String]? { get }
    var queryParameters: Encodable? { get }
    var requestBody: Encodable? { get }
}
