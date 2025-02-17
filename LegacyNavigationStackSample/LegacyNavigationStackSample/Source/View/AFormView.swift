import SwiftUI

/// フォームAの画面を表示するView
struct AFormView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var viewModel: SharedFormViewModel
    /// フローで定義された、このフォームから遷移可能な画面の配列
    let availableRoutes: [AppRoute]
    
    /// 入力値のバリデーション結果
    private var isValidInput: Bool {
        let text = viewModel.formAData.textInput.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 6文字以上16文字以下であることを確認
        guard text.count >= 6 && text.count <= 16 else {
            return false
        }
        
        // 英数字のみが含まれているか確認
        let alphanumericRegex = "^[a-zA-Z0-9]+$"
        guard text.range(of: alphanumericRegex, options: .regularExpression) != nil else {
            return false
        }
        
        // 少なくとも1つの英字が含まれているか確認
        let alphabetRegex = "[a-zA-Z]"
        guard text.range(of: alphabetRegex, options: .regularExpression) != nil else {
            return false
        }
        
        // 少なくとも1つの数字が含まれているか確認
        let numberRegex = "[0-9]"
        guard text.range(of: numberRegex, options: .regularExpression) != nil else {
            return false
        }
        
        return true
    }
    
    var body: some View {
        VStack {
            // フォームのタイトル
            Text("フォームA")
                .font(.title)
            
            // 入力フィールド
            TextField("入力してください", text: $viewModel.formAData.textInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: viewModel.formAData.textInput) { _ in
                    // 入力値が変更されたらエラーメッセージをクリア
                    viewModel.errorMessage = nil
                }
            
            // バリデーションルールの表示
            Text("6〜16文字の英数字（英字・数字をそれぞれ1文字以上）で入力してください")
                .foregroundColor(isValidInput ? .green : .red)
                .font(.caption)
                .padding(.horizontal)
            
            // 特別な入力値の説明
            VStack(alignment: .leading, spacing: 8) {
                Text("特別な入力値:")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text("・111AAA → 再度フォームAを表示")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text("・222BBB → エラー画面を表示")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            .padding(.horizontal)
            
            // エラーメッセージの表示
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            }
            
            // 次へボタン
            Button(action: {
                scanAndNavigate()
            }) {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Text("次へ")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isValidInput ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .disabled(viewModel.isLoading || !isValidInput)
            .padding()
        }
        .padding()
    }
    
    /// フォームの入力値を検証し、結果に応じて画面遷移を行う
    private func scanAndNavigate() {
        Task {
            let result = await viewModel.scanFormA()
            
            await MainActor.run {
                switch result {
                case .valid:
                    // 正常な入力の場合、フローで定義された次の画面に遷移
                    if let nextRoute = availableRoutes.first {
                        router.navigate(to: nextRoute, data: viewModel.formAData)
                    }
                case .invalid(let message):
                    // 無効な入力の場合、エラーメッセージを表示
                    viewModel.errorMessage = message
                case .error:
                    // エラーの場合、エラー画面に遷移
                    viewModel.formAData.errorMessage = "入力されたパスワードが無効です。\n別のパスワードを入力してください。"
                    router.navigate(to: .error, data: viewModel.formAData)
                }
            }
        }
    }
}
