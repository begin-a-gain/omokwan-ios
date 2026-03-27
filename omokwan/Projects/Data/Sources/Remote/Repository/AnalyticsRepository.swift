//
//  AnalyticsRepository.swift
//  Data
//
//  Created by jumy on 3/20/26.
//

import Domain

public struct AnalyticsRepository: AnalyticsRepositoryProtocol {
    private let analyticsService: AnalyticsService

    public init(analyticsService: AnalyticsService) {
        self.analyticsService = analyticsService
    }

    public func track(_ event: AnalyticsEvent) {
        switch event {
        case .appEntry:
            analyticsService.logEvent(
                "app_entry",
                parameters: [
                    "screen_name": "splash_view",
                    "description": "앱 초기 실행"
                ]
            )
        case .autoSignInSuccess:
            analyticsService.logEvent(
                "auto_sign_in_success",
                parameters: [
                    "screen_name": "splash_view",
                    "description": "자동로그인 완료"
                ]
            )
        case .signInSuccess(let provider):
            analyticsService.logEvent(
                "sign_in_success",
                parameters: [
                    "screen_name": "sign_in_view",
                    "description": "[\(provider)]로 로그인 완료"
                ]
            )
        case .signUpSuccess(let provider):
            analyticsService.logEvent(
                "sign_up_success",
                parameters: [
                    "screen_name": "sign_up_done_view",
                    "description": "[\(provider)]로 회원가입 완료"
                ]
            )
        case .enterDetailFromMyGame:
            analyticsService.logButtonTap("my_game_stone_button", screen: "my_game_view")
        case .quickCompleteButtonTap:
            analyticsService.logButtonTap("quick_complete_button", screen: "my_game_view")
        case .putStone:
            analyticsService.logButtonTap("finish_today's_stone_button", screen: "game_detail_view")
        case .kickUser:
            analyticsService.logEvent(
                "kick_user",
                parameters: [
                    "screen_name": "game_detail_view",
                    "description": "디테일 화면에서 강퇴"
                ]
            )
        }
    }

    public func setUserId(_ userId: String?) {
        analyticsService.setUserId(userId)
    }

    public func setAnalyticsEnabled(_ enabled: Bool) {
        analyticsService.setAnalyticsEnabled(enabled)
    }
}
