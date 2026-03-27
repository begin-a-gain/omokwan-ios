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
            analyticsService.logEvent(
                "enter_to_detail",
                parameters: [
                    "screen_name": "my_game_view",
                    "description": "메인 화면에서 디테일 화면 이동"
                ]
            )
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
        case .logout:
            analyticsService.logButtonTap("logout_button", screen: "my_page_view")
        case .accountDeleteEntryTap:
            analyticsService.logButtonTap("account_delete_button", screen: "my_page_view")
        case .accountDeleteSuccess:
            analyticsService.logEvent(
                "delete_account",
                parameters: [
                    "screen_name": "account_delete_view",
                    "description": "회원 탈퇴 처리 완료"
                ]
            )
        case .gameSelfExit:
            analyticsService.logEvent(
                "self_exit",
                parameters: [
                    "screen_name": "game_detail_setting_view",
                    "description": "대국 셀프 나가기 완료"
                ]
            )
        case .participateSuccessFromParticipate:
            analyticsService.logEvent(
                "participate_success",
                parameters: [
                    "screen_name": "my_game_participate_view",
                    "description": "대국 참여 완료"
                ]
            )
        case .notificationButtonTap:
            analyticsService.logButtonTap("notification_button", screen: "my_game_view")
        case .notificationReadAllSuccess:
            analyticsService.logEvent(
                "notification_read_all_success",
                parameters: [
                    "screen_name": "notification_view",
                    "description": "알림 모두 읽기 처리 완료"
                ]
            )
        case .participateSuccessFromNotification:
            analyticsService.logEvent(
                "participate_success",
                parameters: [
                    "screen_name": "notification_view",
                    "description": "알림 화면에서 대국 참여 완료"
                ]
            )
        case .enterDetailFromNotification:
            analyticsService.logButtonTap("notification_card_button", screen: "notification_view")
            analyticsService.logEvent(
                "enter_to_detail",
                parameters: [
                    "screen_name": "notification_view",
                    "description": "알림 화면에서 디테일 화면 이동"
                ]
            )
        case .search:
            analyticsService.logEvent(
                "search_to_participate",
                parameters: [
                    "screen_name": "my_game_participate_view",
                    "description": "대국 참여하기 화면에서 검색으로 대국 찾기"
                ]
            )
        case .setCalendar:
            analyticsService.logEvent(
                "set_calendar",
                parameters: [
                    "screen_name": "my_game_view",
                    "description": "달력 날짜 설정"
                ]
            )
        case .calendarPreviousButtonTap:
            analyticsService.logButtonTap("calendar_previous_button", screen: "my_game_view")
        case .calendarNextButtonTap:
            analyticsService.logButtonTap("calendar_next_button", screen: "my_game_view")
        }
    }

    public func setUserId(_ userId: String?) {
        analyticsService.setUserId(userId)
    }

    public func setAnalyticsEnabled(_ enabled: Bool) {
        analyticsService.setAnalyticsEnabled(enabled)
    }
}
