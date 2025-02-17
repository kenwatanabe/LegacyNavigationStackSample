import SwiftUI

/// 画面遷移のフローを定義する構造体
struct NavigationFlow: Identifiable {
    /// フローを一意に識別するID
    let id: String
    /// フローのタイトル
    let title: String
    /// フローの説明文
    let description: String
    /// フローの開始画面
    let startRoute: AppRoute
    /// 画面間の遷移可能な関係を定義する辞書
    /// - Key: 現在の画面
    /// - Value: 遷移可能な次の画面の配列
    let transitions: [AppRoute: [AppRoute]]
    
    /// NavigationFlowの初期化
    /// - Parameters:
    ///   - id: フローの一意識別子
    ///   - title: フローのタイトル
    ///   - description: フローの説明
    ///   - startRoute: 開始画面
    ///   - transitions: 画面遷移の定義
    init(id: String, title: String, description: String, startRoute: AppRoute, transitions: [AppRoute: [AppRoute]]) {
        self.id = id
        self.title = title
        self.description = description
        self.startRoute = startRoute
        self.transitions = transitions
    }
}

/// フローの状態を管理するクラス
class NavigationFlowManager: ObservableObject {
    /// 現在選択されているフロー
    @Published var currentFlow: NavigationFlow
    /// 利用可能なすべてのフロー
    let availableFlows: [NavigationFlow]
    
    /// NavigationFlowManagerの初期化
    /// - Parameter flows: 利用可能なフローの配列
    init(flows: [NavigationFlow]) {
        self.availableFlows = flows
        self.currentFlow = flows[0]  // 最初のフローをデフォルトとして設定
    }
    
    /// 現在の画面から遷移可能な次の画面を取得
    /// - Parameter currentRoute: 現在の画面
    /// - Returns: 遷移可能な画面の配列
    func getNextRoutes(from currentRoute: AppRoute) -> [AppRoute] {
        return currentFlow.transitions[currentRoute] ?? []
    }
    
    /// 指定されたIDのフローに切り替え
    /// - Parameter flowId: 切り替え先のフローID
    func switchFlow(to flowId: String) {
        if let newFlow = availableFlows.first(where: { $0.id == flowId }) {
            currentFlow = newFlow
        }
    }
}

/// フローの具体的な定義
extension NavigationFlow {
    /// ルートAのフロー定義
    /// チュートリアル → フォームA → 結果
    static let routeA = NavigationFlow(
        id: "routeA",
        title: "ルートA",
        description: "チュートリアル → フォームA → 結果",
        startRoute: .tutorial,
        transitions: [
            .tutorial: [.aForm],
            .aForm: [.result]
        ]
    )
    
    /// ルートBのフロー定義
    /// チュートリアル → フォームA → プレビュー → 結果
    static let routeB = NavigationFlow(
        id: "routeB",
        title: "ルートB",
        description: "チュートリアル → フォームA → プレビュー → 結果",
        startRoute: .tutorial,
        transitions: [
            .tutorial: [.aForm],
            .aForm: [.textPreview],
            .textPreview: [.result]
        ]
    )
    
    /// ルートCのフロー定義
    /// チュートリアル → フォームA → フォームB → プレビュー → 結果
    static let routeC = NavigationFlow(
        id: "routeC",
        title: "ルートC",
        description: "チュートリアル → フォームA → フォームB → プレビュー → 結果",
        startRoute: .tutorial,
        transitions: [
            .tutorial: [.aForm],
            .aForm: [.bForm],
            .bForm: [.textPreview],
            .textPreview: [.result]
        ]
    )
    
    /// ルートDのフロー定義
    /// チュートリアル → フォームB → 結果
    static let routeD = NavigationFlow(
        id: "routeD",
        title: "ルートD",
        description: "チュートリアル → フォームB → 結果",
        startRoute: .tutorial,
        transitions: [
            .tutorial: [.bForm],
            .bForm: [.result]
        ]
    )
    
    /// すべての利用可能なフローを含む配列
    static let allFlows: [NavigationFlow] = [
        .routeA,
        .routeB,
        .routeC,
        .routeD
    ]
}
