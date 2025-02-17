import SwiftUI

struct TextPreviewView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var viewModel: SharedFormViewModel
    let availableRoutes: [AppRoute]
    let previousFormData: FormData?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("プレビュー")
                .font(.title)
            
            VStack(alignment: .leading, spacing: 16) {
                Text("入力内容:")
                    .font(.headline)
                
                if router.navigationStack.contains(where: { $0.route == .aForm }) {
                    Text("フォームAの入力: \(viewModel.formAData.textInput)")
                }
                
                if router.navigationStack.contains(where: { $0.route == .bForm }) {
                    Text("フォームBの入力: \(viewModel.formBData.textInput)")
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            
            Spacer()
            
            VStack(spacing: 16) {
                // 次へボタン
                Button(action: {
                    if let nextRoute = availableRoutes.first {
                        router.navigate(to: nextRoute, data: previousFormData)
                    }
                }) {
                    Text("次へ")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                // 失敗ボタン
                Button(action: {
                    // navigationStackを逆順に走査して最初のフォーム画面を見つける
                    if let firstFormIndex = router.navigationStack.firstIndex(where: { 
                        let route = $0.route
                        return route == .aForm || route == .bForm 
                    }) {
                        // フォームのデータをクリア
                        if router.navigationStack.contains(where: { $0.route == .aForm }) {
                            viewModel.formAData = FormData()
                        }
                        if router.navigationStack.contains(where: { $0.route == .bForm }) {
                            viewModel.formBData = FormData()
                        }
                        
                        router.transitionDirection = .backward  // 戻るアニメーションを設定
                        // 最初のフォーム以降のスタックを削除
                        router.navigationStack.removeSubrange((firstFormIndex + 1)...)
                        router.currentRoute = router.navigationStack[firstFormIndex].route
                    }
                }) {
                    Text("入力をやり直す")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                // エラーボタン
                Button(action: {
                    let data = FormData()
                    data.errorMessage = "プレビュー画面でエラーが発生しました。\n最初からやり直してください。"
                    router.navigate(to: .error, data: data)
                }) {
                    Text("エラー画面へ")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .padding()
    }
}
