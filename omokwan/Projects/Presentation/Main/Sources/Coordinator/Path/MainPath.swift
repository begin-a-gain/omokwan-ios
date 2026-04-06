//
//  MainPath.swift
//  Main
//
//  Created by 김동준 on 11/20/24
//

import ComposableArchitecture
import MyGame
import MyGameAdd
import MyGameParticipate
import GameDetail
import MyPage
import Notification

extension MainCoordinatorFeature {
    @Reducer
    public enum MainPath {
        case myGame(MyGameFeature)
        case myGameAdd(MyGameAddFeature)
        case myGameAddCategory(MyGameAddCategoryFeature)
        case myGameParticipate(MyGameParticipateFeature)
        case gameDetail(GameDetailFeature)
        case gameDetailSetting(GameDetailSettingFeature)
        case invitation(InvitationFeature)
        case hostChange(HostChangeFeature)
        case editNickname(EditNicknameFeature)
        case accountDelete(AccountDeleteFeature)
        case myPageGameDetail(MyPageGameDetailFeature)
        case notification(NotificationFeature)
    }
}
