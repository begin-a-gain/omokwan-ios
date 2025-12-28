//
//  NetworkLogging.swift
//  Data
//
//  Created by 김동준 on 12/28/25
//

import Foundation
import Util

struct NetworkLogging {
    private var output = ""

    mutating func request(request: URLRequest) {
        output += "🚀 Request URL     : \(request.url?.absoluteString ?? "")\n"
        output += "📥 HTTP Method     : \(request.httpMethod ?? "")\n"
        output += "📨 HTTP Headers    : \(request.allHTTPHeaderFields ?? [:])\n"
    }
    
    mutating func bodyIfNeeded(_ body: Data?) {
        guard let body else { return }
        self.body(body)
    }

    mutating func body(_ body: Data) {
        if let pretty = body.prettyJSONString() {
            output += "📦 HTTP Body       : \(pretty)\n"
        } else {
            output += "📦 HTTP Body       : <Non-UTF8 Data: \(body.count) bytes>\n"
        }
    }

    mutating func response(data: Data, response: URLResponse) {
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { return }

        output += "📊 Status Code     : \(statusCode)\n"

        if let pretty = data.prettyJSONString() {
            output += "🧾 Response Body   : \(pretty)\n"
        } else {
            output += "🧾 Response Body   : <\(data.count) bytes>\n"
        }

        output += "-----------------------------\n"
    }
    
    func printLog() {
        OLogger.network.log(output)
    }
}
