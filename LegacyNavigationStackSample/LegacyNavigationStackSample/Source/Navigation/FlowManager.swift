import SwiftUI

/// アプリケーション内の画面遷移フローを管理するクラス
class FlowManager: ObservableObject {
    /// 現在選択されているフロー
    @Published var currentFlow: NavigationFlow
    /// 利用可能なすべてのフロー
    @Published var availableFlows: [NavigationFlow]
    
    /// FlowManagerの初期化
    /// 定義済みの4つのフローを設定し、最初のフローをデフォルトとして選択
    init() {
        let flows = [
            NavigationFlow.routeA,
            NavigationFlow.routeB,
            NavigationFlow.routeC,
            NavigationFlow.routeD
        ]
        self.availableFlows = flows
        self.currentFlow = flows[0]   // 最初のフローをデフォルトとして設定
    }
    
    /// 現在の画面から遷移可能な次の画面を取得
    /// - Parameter currentRoute: 現在表示中の画面
    /// - Returns: 遷移可能な画面の配列（定義されていない場合は空配列）
    func getNextRoutes(from currentRoute: AppRoute) -> [AppRoute] {
        return currentFlow.transitions[currentRoute] ?? []
    }
    
    /// 指定されたIDのフローに切り替える
    /// - Parameter flowId: 切り替えたいフローのID
    func selectFlow(_ flowId: String) {
        if let flow = availableFlows.first(where: { $0.id == flowId }) {
            currentFlow = flow
        }
    }
}
