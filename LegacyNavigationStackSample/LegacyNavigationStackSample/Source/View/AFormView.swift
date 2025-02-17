import SwiftUI

struct AFormView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var viewModel: SharedFormViewModel
    let availableRoutes: [AppRoute]
    
    private var isValidInput: Bool {
        let text = viewModel.formAData.textInput.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 文字数チェック
        guard text.count >= 6 && text.count <= 16 else {
            return false
        }
        
        // 英数字のみかチェック
        let alphanumericRegex = "^[a-zA-Z0-9]+$"
        guard text.range(of: alphanumericRegex, options: .regularExpression) != nil else {
            return false
        }
        
        // 英字を含むかチェック
        let alphabetRegex = "[a-zA-Z]"
        guard text.range(of: alphabetRegex, options: .regularExpression) != nil else {
            return false
        }
        
        // 数字を含むかチェック
        let numberRegex = "[0-9]"
        guard text.range(of: numberRegex, options: .regularExpression) != nil else {
            return false
        }
        
        return true
    }
    
    var body: some View {
        VStack {
            Text("フォームA")
                .font(.title)
            
            TextField("入力してください", text: $viewModel.formAData.textInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: viewModel.formAData.textInput) { _ in
                    viewModel.errorMessage = nil
                }
            
            Text("6〜16文字の英数字（英字・数字をそれぞれ1文字以上）で入力してください")
                .foregroundColor(isValidInput ? .green : .red)
                .font(.caption)
                .padding(.horizontal)
            
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
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Button(action: {
                validateAndNavigate()
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
    
    private func validateAndNavigate() {
        Task {
            let result = await viewModel.validateFormA()
            
            await MainActor.run {
                switch result {
                case .valid:
                    if let nextRoute = availableRoutes.first {
                        router.navigate(to: nextRoute, data: viewModel.formAData)
                    }
                case .invalid(let message):
                    viewModel.errorMessage = message
                    if viewModel.formAData.textInput == "111AAA" {
                        router.navigate(to: .aForm, data: viewModel.formAData)
                    }
                case .error:
                    viewModel.formAData.errorMessage = "入力されたパスワードが無効です。\n別のパスワードを入力してください。"
                    router.navigate(to: .error, data: viewModel.formAData)
                }
            }
        }
    }
}
