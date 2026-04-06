//
//  MyGameAddCategoryFeature.swift
//  MyGameAdd
//
//  Created by 김동준 on 11/30/24
//

import ComposableArchitecture
import Domain
import Base

@Reducer
public struct MyGameAddCategoryFeature {
    @Dependency(\.gameUseCase) private var gameUseCase

    public init() {}
    
    public struct State: Equatable {
        public init() {}
        
        // MARK: Alert
        public enum AlertCase: Equatable {
            case error(NetworkError)
        }
        
        var alertCase: AlertCase?
        var alertState: AlertFeature.State = .init()
        var isLoading: Bool = false
        
        var categories: [GameCategory] = []
        var selectedCategory: GameCategory?
        var isNextButtonEnable: Bool {
            return selectedCategory != nil
        }
    }
    
    public enum Action {
        case onAppear
        case alertAction(AlertFeature.Action)
        case showAlert(State.AlertCase)
        case skipButtonTapped([GameCategory])
        case nextButtonTapped([GameCategory], GameCategory?)
        case categoryTapped(String)
        case navigateToBack
        case categoriesFetched([GameCategory])
    }
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.alertState, action: \.alertAction) {
            AlertFeature()
        }

        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .run { send in
                    await send(fetchCategories())
                }
            case .skipButtonTapped:
                return .none
            case .nextButtonTapped:
                return .none
            case .categoryTapped(let category):
                if let selectedCategory = state.selectedCategory, selectedCategory.category == category {
                    state.selectedCategory = nil
                } else {
                    state.selectedCategory = state.categories.first { $0.category == category }
                }
                
                return .none
            case .navigateToBack:
                return .none
            case .alertAction:
                return .none
            case .showAlert(let alertCase):
                state.isLoading = false
                state.alertCase = alertCase
                return .send(.alertAction(.present))
            case .categoriesFetched(let categories):
                state.isLoading = false
                state.categories = categories
                return .none
            }
        }
    }
}

private extension MyGameAddCategoryFeature {
    func fetchCategories() async -> Action {
        let response = await gameUseCase.fetchGameCategories()
        switch response {
        case .success(let categories):
            return .categoriesFetched(categories)
        case .failure(let error):
            return .showAlert(.error(error))
        }
    }
}
