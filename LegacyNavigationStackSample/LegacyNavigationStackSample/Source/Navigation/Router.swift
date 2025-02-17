import SwiftUI

/// アプリケーションの画面遷移を管理するクラス
class Router: ObservableObject {
    /// 現在表示中の画面
    @Published var currentRoute: AppRoute = .home
    
    /// 画面遷移の履歴とフォームデータを保持する配列
    /// - route: 画面の種類
    /// - data: その画面に関連するフォームデータ（オプショナル）
    @Published var navigationStack: [(route: AppRoute, data: FormData?)] = []
    
    /// 画面遷移のアニメーション方向
    @Published var transitionDirection: TransitionDirection = .forward
    
    /// 新しい画面へ遷移する
    /// - Parameters:
    ///   - route: 遷移先の画面
    ///   - data: 遷移先に渡すフォームデータ（オプショナル）
    func navigate(to route: AppRoute, data: FormData? = nil) {
        // エラー画面への遷移の場合はモーダル表示
        if route == .error {
            transitionDirection = .modal
        }
        // それ以外は通常の前方遷移
        else {
            transitionDirection = .forward
        }
        
        // 新しい画面をスタックに追加し、現在の画面を更新
        navigationStack.append((route: route, data: data))
        currentRoute = route
    }
    
    /// 前の画面に戻る
    /// - Parameter viewModel: フォームデータを管理するViewModel
    func navigateBack(viewModel: SharedFormViewModel) {
        // スタックが空の場合は何もしない
        guard !navigationStack.isEmpty else { return }
        
        // エラー画面から戻る場合はモーダル、それ以外は後方遷移
        transitionDirection = currentRoute == .error ? .modal : .backward
        
        // 現在の画面のフォームデータをクリア
        let currentRoute = navigationStack.last?.route
        switch currentRoute {
        case .aForm:
            viewModel.formAData = FormData()
        case .bForm:
            viewModel.formBData = FormData()
        default:
            break
        }
        
        // スタックから現在の画面を削除し、一つ前の画面を現在の画面に設定
        navigationStack.removeLast()
        self.currentRoute = navigationStack.last?.route ?? .home
    }
    
    /// ホーム画面に直接戻る（スタックをクリア）
    func navigateToRoot() {
        transitionDirection = .none  // アニメーションなし
        navigationStack.removeAll()   // スタックを空にする
        currentRoute = .home         // ホーム画面を表示
    }
    
    /// 現在の画面に関連するフォームデータを取得
    /// - Returns: 現在の画面のフォームデータ（存在する場合）
    func getCurrentData() -> FormData? {
        return navigationStack.last?.data
    }
    
    /// 最初のフォーム画面に戻る
    /// スタック内のAFormまたはBFormのうち、最後に表示されたものまでスタックを戻す
    func navigateToFirstForm() {
        if let firstFormIndex = navigationStack.enumerated().reversed().first(where: {
            let route = $0.element.route
            return route == .aForm || route == .bForm
        })?.offset {
            // 見つかったフォーム以降の画面をスタックから削除
            navigationStack.removeSubrange((firstFormIndex + 1)...)
            currentRoute = navigationStack.last?.route ?? .home
        }
    }
    
    // 特定の画面まで戻る
    func navigateBackTo(route: AppRoute) {
        guard let index = navigationStack.lastIndex(where: { $0.route == route }) else { return }
        transitionDirection = .backward
        navigationStack.removeSubrange((index + 1)...)
        currentRoute = route
    }
    
    /// ナビゲーション状態を完全にリセット
    /// すべての履歴を削除してホーム画面に戻す
    func cleanup() {
        navigationStack.removeAll()
        currentRoute = .home
        
        #if DEBUG
        print("Navigation stack cleaned up")
        #endif
    }
}
