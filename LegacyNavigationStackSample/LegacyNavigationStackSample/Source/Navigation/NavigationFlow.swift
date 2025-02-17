import SwiftUI

// フローの定義
struct NavigationFlow: Identifiable {
    let id: String
    let title: String
    let description: String
    let startRoute: AppRoute
    let transitions: [AppRoute: [AppRoute]]
    
    init(id: String, title: String, description: String, startRoute: AppRoute, transitions: [AppRoute: [AppRoute]]) {
        self.id = id
        self.title = title
        self.description = description
        self.startRoute = startRoute
        self.transitions = transitions
    }
}

// フローの管理
class NavigationFlowManager: ObservableObject {
    @Published var currentFlow: NavigationFlow
    let availableFlows: [NavigationFlow]
    
    init(flows: [NavigationFlow]) {
        self.availableFlows = flows
        self.currentFlow = flows[0]
    }
    
    func getNextRoutes(from currentRoute: AppRoute) -> [AppRoute] {
        return currentFlow.transitions[currentRoute] ?? []
    }
    
    func switchFlow(to flowId: String) {
        if let newFlow = availableFlows.first(where: { $0.id == flowId }) {
            currentFlow = newFlow
        }
    }
}

// フローの定義例
extension NavigationFlow {
    // 利用可能なフローの定義
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
    
    // デフォルトで利用可能なすべてのフロー
    static let allFlows: [NavigationFlow] = [
        .routeA,
        .routeB,
        .routeC,
        .routeD
    ]
} 
