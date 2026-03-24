//
//  RemoteConfigValue.swift
//  Domain
//
//  Created by jumy on 3/21/26.
//

import Foundation

public enum RemoteConfigValueType {
    case bool
    case string
    case int
    case double
    case data
}

public enum RemoteConfigResultData: Equatable {
    case bool(Bool)
    case string(String)
    case int(Int)
    case double(Double)
    case data(Data)
}
