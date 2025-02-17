import SwiftUI

/// アプリケーションの画面を管理し、適切なViewを表示するコンテナView
struct NavHost: View {
    @EnvironmentObject var router: Router                      // 画面遷移を管理
    @EnvironmentObject var viewModel: SharedFormViewModel      // フォームデータを管理
    @StateObject private var flowManager = FlowManager()       // 画面遷移フローを管理
    /// 現在表示すべき画面
    let route: AppRoute
    
    var body: some View {
        Group {
            switch route {
            case .home:
                HomeView()
                    .environmentObject(flowManager)
                    .onAppear {
                        // ホーム画面表示時にすべての状態をリセット
                        viewModel.reset()
                        router.cleanup()
                    }
            case .tutorial:
                // チュートリアル画面
                // 次に遷移可能な画面の情報を渡す
                TutorialView(availableRoutes: flowManager.getNextRoutes(from: .tutorial))
                
            case .aForm:
                // フォームA画面
                // フローで定義された次の遷移先を渡す
                AFormView(availableRoutes: flowManager.getNextRoutes(from: .aForm))
                
            case .bForm:
                // フォームB画面
                // 遷移先の情報と前の画面のフォームデータを渡す
                BFormView(
                    availableRoutes: flowManager.getNextRoutes(from: .bForm),
                    previousFormData: router.getCurrentData()
                )
                
            case .textPreview:
                // プレビュー画面
                // 遷移先の情報と前の画面のフォームデータを渡す
                TextPreviewView(
                    availableRoutes: flowManager.getNextRoutes(from: .textPreview),
                    previousFormData: router.getCurrentData()
                )
                
            case .result:
                // 結果表示画面
                ResultView()
                
            case .error:
                // エラー画面
                // エラーメッセージがない場合はデフォルトメッセージを表示
                ErrorView(errorMessage: router.getCurrentData()?.errorMessage ?? "エラーが発生しました")
            }
        }
    }
}
