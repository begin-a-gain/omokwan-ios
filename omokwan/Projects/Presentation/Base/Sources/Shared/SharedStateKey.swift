//
//  SharedStateKey.swift
//  Base
//
//  Created by 김동준 on 7/20/25
//

import ComposableArchitecture
import Domain

extension SharedKey where Self == InMemoryKey<UserInfo> {
    static public var userInfo: Self {
        inMemory("userInfo")
    }
}
