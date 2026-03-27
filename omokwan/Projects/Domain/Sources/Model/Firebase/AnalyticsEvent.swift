//
//  AnalyticsEvent.swift
//  Domain
//
//  Created by jumy on 3/20/26.
//

public enum AnalyticsEvent: Equatable {
    case appEntry
    case autoSignInSuccess
    case signInSuccess(provider: String)
    case signUpSuccess(provider: String)
    case enterDetailFromMyGame
    case quickCompleteButtonTap
    case putStone
    case kickUser
    case logout
    case accountDeleteEntryTap
    case accountDeleteSuccess
    case gameSelfExit
    case participateSuccessFromParticipate
    case notificationButtonTap
    case notificationReadAllSuccess
    case participateSuccessFromNotification
    case enterDetailFromNotification
    case search
}
