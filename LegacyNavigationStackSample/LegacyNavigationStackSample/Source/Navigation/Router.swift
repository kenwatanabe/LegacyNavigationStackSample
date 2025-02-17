import SwiftUI

class Router: ObservableObject {
    @Published var currentRoute: AppRoute = .home
    @Published var navigationStack: [(route: AppRoute, data: FormData?)] = []
    @Published var transitionDirection: TransitionDirection = .forward
    
    func navigate(to route: AppRoute, data: FormData? = nil) {
        // エラー画面への遷移の場合
        if route == .error {
            transitionDirection = .modal
        }
        // それ以外の通常の遷移
        else {
            transitionDirection = .forward
        }
        
        navigationStack.append((route: route, data: data))
        currentRoute = route
    }
    
    func navigateBack(viewModel: SharedFormViewModel) {
        guard !navigationStack.isEmpty else { return }
        transitionDirection = currentRoute == .error ? .modal : .backward
        
        // 現在の画面のデータをクリア
        let currentRoute = navigationStack.last?.route
        switch currentRoute {
        case .aForm:
            viewModel.formAData = FormData()
        case .bForm:
            viewModel.formBData = FormData()
        default:
            break
        }
        
        navigationStack.removeLast()
        self.currentRoute = navigationStack.last?.route ?? .home
    }
    
    func navigateToRoot() {
        transitionDirection = .none  // アニメーションなし
        navigationStack.removeAll()
        currentRoute = .home
    }
    
    func getCurrentData() -> FormData? {
        return navigationStack.last?.data
    }
    
    func navigateToFirstForm() {
        if let firstFormIndex = navigationStack.enumerated().reversed().first(where: { 
            let route = $0.element.route
            return route == .aForm || route == .bForm 
        })?.offset {
            navigationStack.removeSubrange((firstFormIndex + 1)...)
            currentRoute = navigationStack.last?.route ?? .home
        }
    }
    
    func cleanup() {
        navigationStack.removeAll()
        currentRoute = .home
        
        #if DEBUG
        print("Navigation stack cleaned up")
        #endif
    }
}
