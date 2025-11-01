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
    @Dependency(\.mainQueue) private var mainQueue

    public init() {}
    
    public struct State: Equatable {
        public init() {}
        
        enum CancellableID {
            case initFetch
        }
        
        enum SearchDebounceID {
            case id
        }
        
        public enum AlertCase: Equatable {
            case error(NetworkError)
            case participateDoubleCheck(GameRoomInformation)
            case password(GameRoomInformation)
            case passwordError
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
            selectedCategoryList.count
        }
        var isCategoryFilterSelected: Bool {
            return !selectedCategoryList.isEmpty
        }
        
        @PresentationState var categorySheet: MyGameParticipateCategorySheetFeature.State?
        
        var selectedCategoryList: [GameCategory] = []
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
        case passwordAlertConfirmButtonTapped(GameRoomInformation)
        
        case setLoading(Bool)
        case initialDataFetchFailed(NetworkError)
        case gameInfoListFetched([GameRoomInformation])
        case fetchInfoList
        case participateRoom(GameRoomInformation, String?)
        case participateCompleted(GameRoomInformation)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
            .onChange(of: \.searchText) { oldValue, newValue in
                Reduce { state, action in
                    if oldValue.isEmpty, newValue.isEmpty { return .none }
                    return .send(.fetchInfoList)
                        .debounce(
                            id: State.SearchDebounceID.id,
                            for: .milliseconds(500),
                            scheduler: mainQueue
                        )
                }
            }

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
                    .send(.showAlert(alertCase))
                ])
            case .setLoading(let value):
                state.isLoading = value
                return .none
            case .onAppear:
                let request = GameRoomInformationRequestModel(
                    joinable: state.isAvailableParticipateRoomSelected ? true : nil,
                    categoryList: state.selectedCategoryList.isEmpty ? nil : state.selectedCategoryList,
                    search: state.searchText,
                    pageNumber: 1,
                    pageSize: 1000 // 임시로 넣음
                )
                
                return .concatenate([
                    .send(.setLoading(true)),
                    .run { send in
                        await fetchInitData(send: send, request: request)
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
                state.selectedCategoryList = []
                return .send(.fetchInfoList)
            case .availableParticipateRoomFilterTapped:
                state.isAvailableParticipateRoomSelected.toggle()
                return .send(.fetchInfoList)
            case .categoryFilterTapped:
                state.categorySheet = .init(
                    categories: state.categories,
                    selectedCategoryList: state.selectedCategoryList
                )
                return .none
            case .searchBarClearButtonTapped:
                state.searchText = ""
                return .send(.fetchInfoList)
            case .categorySheet(let categorySheetAction):
                switch categorySheetAction {
                case .presented(let sheetAction):
                    switch sheetAction {
                    case .passSelectedCategories(let selectedCategories):
                        state.selectedCategoryList = selectedCategories
                        state.categorySheet = nil
                        
                        return .send(.fetchInfoList)
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
                    return .merge([
                        .send(.alertAction(.dismiss)),
                        .send(.participateRoom(roomInfo, nil))
                    ])
                } else {
                    state.alertCase = .password(roomInfo)
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
            case .passwordAlertConfirmButtonTapped(let roomInfo):
                guard let thousands = Int(state.thousandsPlace),
                      let hundreds = Int(state.hundredsPlace),
                      let tens = Int(state.tensPlace),
                      let ones = Int(state.onesPlace)
                else { return .none }
                
                let password = (1000 * thousands) + (100 * hundreds) + (10 * tens) + ones
                
                return .merge([
                    .send(.alertAction(.dismiss)),
                    .send(.participateRoom(roomInfo, String(password)))
                ])
            case .initialDataFetchFailed(let error):
                return .merge([
                    .cancel(id: State.CancellableID.initFetch),
                    .send(.showAlert(.error(error)))
                ])
            case .gameInfoListFetched(let infoList):
                state.gameRoomInformationList = infoList
                return .none
            case .fetchInfoList:
                let request = GameRoomInformationRequestModel(
                    joinable: state.isAvailableParticipateRoomSelected ? true : nil,
                    categoryList: state.selectedCategoryList.isEmpty ? nil : state.selectedCategoryList,
                    search: state.searchText,
                    pageNumber: 1,
                    pageSize: 1000 // 임시로 넣음
                )

                return .concatenate([
                    .send(.setLoading(true)),
                    .run { send in
                        do {
                            let result = try await fetchGameRoomInfo(request: request)
                            await send(.gameInfoListFetched(result))
                        } catch let error as NetworkError {
                            await send(.showAlert(.error(error)))
                        } catch {
                            await send(.showAlert(.error(.unKnownError)))
                        }
                    },
                    .send(.setLoading(false))
                ])
            case let .participateRoom(roomInfo, password):
                state.isLoading = true
                
                return .run { send in
                    await send(participateRoom(roomInfo: roomInfo, password: password))
                }
            case .participateCompleted(let roomInfo):
                state.isLoading = false
                let selectedDateString = Date.now.formattedString(
                    format: DateFormatConstants.yearMonthDayRequestFormat
                )

                return .send(.navigateToGameDetail(roomInfo.id, roomInfo.name, selectedDateString))
            }
        }
        .ifLet(\.$categorySheet, action: \.categorySheet) {
            MyGameParticipateCategorySheetFeature()
        }
    }
}

private extension MyGameParticipateFeature {
    func fetchInitData(
        send: Send<Action>,
        request: GameRoomInformationRequestModel
    ) async {
        do {
            async let categories = fetchCategories()
            async let roomInformation = fetchGameRoomInfo(request: request)

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
    
    func fetchGameRoomInfo(request: GameRoomInformationRequestModel) async throws -> [GameRoomInformation] {
        let response = await gameUseCase.fetchAllGameInfoList(request)
        switch response {
        case .success(let gameInfoList):
            return gameInfoList
        case .failure(let error):
            throw error
        }
    }
    
    func participateRoom(roomInfo: GameRoomInformation, password: String? = nil) async -> Action {
        let response = await gameUseCase.participateRoom(roomInfo.id, password)
        switch response {
        case .success(let isParticipateSuccess):
            if isParticipateSuccess {
                return .participateCompleted(roomInfo)
            } else {
                return .showAlert(.passwordError)
            }
        case .failure(let error):
            return .showAlert(.error(error))
        }
    }
}
