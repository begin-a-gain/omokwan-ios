//
//  MainCoordinatorScreen.swift
//  Main
//
//  Created by 김동준 on 11/20/24
//

import ComposableArchitecture
import MyGame
import MyGameAdd
import MyGameParticipate
import GameDetail

extension MainCoordinatorFeature {
    @Reducer
    public struct MainPath {
        public enum State: Equatable {
            case myGame(MyGameFeature.State)
            case myGameAdd(MyGameAddFeature.State)
            case myGameAddCategory(MyGameAddCategoryFeature.State)
            case myGameParticipate(MyGameParticipateFeature.State)
            case gameDetail(GameDetailFeature.State)
            case gameDetailSetting(GameDetailSettingFeature.State)
        }

        public enum Action {
            case myGame(MyGameFeature.Action)
            case myGameAdd(MyGameAddFeature.Action)
            case myGameAddCategory(MyGameAddCategoryFeature.Action)
            case myGameParticipate(MyGameParticipateFeature.Action)
            case gameDetail(GameDetailFeature.Action)
            case gameDetailSetting(GameDetailSettingFeature.Action)
        }
        
        public var body: some ReducerOf<Self> {
            Scope(state: \.myGame, action: \.myGame) {
                MyGameFeature()
            }
            Scope(state: \.myGameAdd, action:\.myGameAdd) {
                MyGameAddFeature()
            }
            Scope(state: \.myGameAddCategory, action: \.myGameAddCategory) {
                MyGameAddCategoryFeature()
            }
            Scope(state: \.myGameParticipate, action: \.myGameParticipate) {
                MyGameParticipateFeature()
            }
            Scope(state: \.gameDetail, action: \.gameDetail) {
                GameDetailFeature()
            }
            Scope(state: \.gameDetailSetting, action: \.gameDetailSetting) {
                GameDetailSettingFeature()
            }
        }
    }
}
