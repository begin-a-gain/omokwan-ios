//
//  MyGameAddFeature.swift
//  MyGameAdd
//
//  Created by 김동준 on 11/30/24
//

import Foundation
import ComposableArchitecture

public struct MyGameAddFeature: Reducer {
    public init() {}
    
    public struct State: Equatable {
        public init() {}
    }
    
    public enum Action {
        
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            }
        }
    }
}
