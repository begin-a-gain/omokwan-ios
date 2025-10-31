//
//  MyGameParticipateFeature.swift
//  MyGameParticipate
//
//  Created by 김동준 on 1/1/25
//

import ComposableArchitecture
import Domain
import Base
import Foundation
import Util

@Reducer
public struct MyGameParticipateFeature {
    @Dependency(\.gameUseCase) private var gameUseCase

    public init() {}
    
    public struct State: Equatable {
        public init() {}
        
        enum CancellableID {
            case initFetch
        }
        
        public enum AlertCase: Equatable {
            case error(NetworkError)
            case participateDoubleCheck(GameRoomInformation)
            case password
        }
        var alertCase: AlertCase?
        var alertState: AlertFeature.State = .init()
        var isLoading: Bool = false

        enum CategoryFilterType {
            case availableRoom
            case category
        }
        
        @BindingState var searchText: String = ""
        
        var isResetFilterButtonVisible: Bool {
            return isAvailableParticipateRoomSelected || isCategoryFilterSelected
        }
        
        // About Filter
        var isAvailableParticipateRoomSelected: Bool = false
        var numOfCategory: Int {
            selectedCategoryTitles.count
        }
        var isCategoryFilterSelected: Bool {
            return !selectedCategoryTitles.isEmpty
        }
        
        @PresentationState var categorySheet: MyGameParticipateCategorySheetFeature.State?
        
        var selectedCategoryTitles: [String] = []
        var gameRoomInformationList: [GameRoomInformation] = []
        var categories: [GameCategory] = []
        
        @BindingState var thousandsPlace: String = ""
        @BindingState var hundredsPlace: String = ""
        @BindingState var tensPlace: String = ""
        @BindingState var onesPlace: String = ""
    }
    
    public enum Action: BindableAction {
        case onAppear
        case binding(BindingAction<State>)
        case showAlert(State.AlertCase)
        case handleInitDataError(State.AlertCase)

        case navigateToBack
        case resetFilterButtonTapped
        case availableParticipateRoomFilterTapped
        case categoryFilterTapped
        case searchBarClearButtonTapped
        case categorySheet(PresentationAction<MyGameParticipateCategorySheetFeature.Action>)
        case participateButtonTapped(GameRoomInformation)
        case showDoubleCheckAlert(GameRoomInformation)
        case alertAction(AlertFeature.Action)
        case alertParticipateButtonTapped(GameRoomInformation)
        case navigateToGameDetail(Int, String, String)
        
        case categoriesFetched([GameCategory])
        case passwordAlertCancelButtonTapped
        case passwordAlertConfirmButtonTapped
        
        case setLoading(Bool)
        case initialDataFetchFailed(NetworkError)
        case gameInfoListFetched([GameRoomInformation])
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Scope(state: \.alertState, action: \.alertAction) {
            AlertFeature()
        }
        Reduce { state, action in
            switch action {
            case .alertAction:
                return .none
            case .showAlert(let alertCase):
                state.isLoading = false
                state.alertCase = alertCase
                return .send(.alertAction(.present))
            case .handleInitDataError(let alertCase):
                state.alertCase = alertCase
                return .merge([
                    .cancel(id: State.CancellableID.initFetch),
                    .send(.alertAction(.present))
                ])
            case .setLoading(let value):
                state.isLoading = value
                return .none
            case .onAppear:
                return .concatenate([
                    .send(.setLoading(true)),
                    .run { send in
                        await fetchInitData(send: send)
                    },
                    .send(.setLoading(false))
                ])
                .cancellable(id: State.CancellableID.initFetch)
            case .binding:
                return .none
            case .navigateToBack:
                return .none
            case .resetFilterButtonTapped:
                state.isAvailableParticipateRoomSelected = false
                state.selectedCategoryTitles = []
                return .none
            case .availableParticipateRoomFilterTapped:
                state.isAvailableParticipateRoomSelected.toggle()
                return .none
            case .categoryFilterTapped:
                state.categorySheet = .init(
                    categories: state.categories,
                    selectedCategoryTitles: state.selectedCategoryTitles
                )
                return .none
            case .searchBarClearButtonTapped:
                state.searchText = ""
                return .none
            case .categorySheet(let categorySheetAction):
                switch categorySheetAction {
                case .presented(let sheetAction):
                    switch sheetAction {
                    case .passSelectedCategories(let selectedCategories):
                        state.selectedCategoryTitles = selectedCategories
                        state.categorySheet = nil
                        
                        return .none
                    default:
                        return .none
                    }
                case .dismiss:
                    return .none
                }
            case .participateButtonTapped(let roomInfo):
                switch roomInfo.joinStatus {
                case .possible:
                    return .send(.showDoubleCheckAlert(roomInfo))
                default:
                    return .none
                }
            case .showDoubleCheckAlert(let roomInfo):
                state.alertCase = .participateDoubleCheck(roomInfo)
                return .send(.alertAction(.present))
            case .alertParticipateButtonTapped(let roomInfo):
                if roomInfo.isPublic {
                    let selectedDateString = Date.now.formattedString(format: DateFormatConstants.yearMonthDayRequestFormat)
                    return .merge([
                        .send(.alertAction(.dismiss)),
                        // TODO: 나중에 API 나오고 roomInfo modeling 변경, 넘기는 파라미터 수정
                        .send(.navigateToGameDetail(1, roomInfo.name, selectedDateString))
                    ])
                } else {
                    // TODO: 비공개코드 alert 필요
                    state.alertCase = .password
                    return .none
                }
            case .navigateToGameDetail:
                return .none
            case .categoriesFetched(let categories):
                state.isLoading = false
                state.categories = categories
                return .none
            case .passwordAlertCancelButtonTapped:
                return .send(.alertAction(.dismiss))
            case .passwordAlertConfirmButtonTapped:
                guard let thousands = Int(state.thousandsPlace),
                      let hundreds = Int(state.hundredsPlace),
                      let tens = Int(state.tensPlace),
                      let ones = Int(state.onesPlace)
                else { return .none }
                
                let password = (1000 * thousands) + (100 * hundreds) + (10 * tens) + ones
                
                print("password = \(password)")
                // TODO: 참여 API 호출
                
                return .send(.alertAction(.dismiss))
            case .initialDataFetchFailed(let error):
                return .merge([
                    .cancel(id: State.CancellableID.initFetch),
                    .send(.showAlert(.error(error)))
                ])
            case .gameInfoListFetched(let infoList):
                state.isLoading = false
                state.gameRoomInformationList = infoList
                return .none
            }
        }
        .ifLet(\.$categorySheet, action: \.categorySheet) {
            MyGameParticipateCategorySheetFeature()
        }
    }
}

private extension MyGameParticipateFeature {
    func fetchInitData(send: Send<Action>) async {
        do {
            async let categories = fetchCategories()
            async let roomInformation = fetchGameRoomInfo(pageNumber: 1)

            let (categoriesResult, roomInfoResult) = try await (categories, roomInformation)

            await send(.categoriesFetched(categoriesResult))
            await send(.gameInfoListFetched(roomInfoResult))
        } catch let error as NetworkError {
            await send(.handleInitDataError(.error(error)))
        } catch {
            await send(.handleInitDataError(.error(.unKnownError)))
        }
    }

    func fetchCategories() async throws -> [GameCategory] {
        let response = await gameUseCase.fetchGameCategories()
        switch response {
        case .success(let categories):
            return categories
        case .failure(let error):
            throw error
        }
    }
    
    func fetchGameRoomInfo(
        joinable: Bool = false,
        category: GameCategory? = nil,
        search: String? = nil,
        pageNumber: Int
    ) async throws -> [GameRoomInformation] {
        let request = GameRoomInformationRequestModel(
            joinable: joinable,
            category: category,
            search: search,
            pageNumber: pageNumber
        )
        
        let response = await gameUseCase.fetchAllGameInfoList(request)
        switch response {
        case .success(let gameInfoList):
            return gameInfoList
        case .failure(let error):
            throw error
        }
    }
}
