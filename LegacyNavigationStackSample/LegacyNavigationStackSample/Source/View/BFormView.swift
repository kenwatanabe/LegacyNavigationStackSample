import SwiftUI

struct BFormView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var viewModel: SharedFormViewModel
    let availableRoutes: [AppRoute]
    let previousFormData: FormData?
    
    private var isValidInput: Bool {
        let text = viewModel.formBData.textInput.trimmingCharacters(in: .whitespacesAndNewlines)
        let numberRegex = "^[0-9]{4}$"
        return text.range(of: numberRegex, options: .regularExpression) != nil
    }
    
    var body: some View {
        VStack {
            Text("フォームB")
                .font(.title)
            
            if let previousData = previousFormData {
                Text("フォームAの入力: \(previousData.textInput)")
                    .padding()
            }
            
            TextField("4桁の数字を入力", text: $viewModel.formBData.textInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding()
                .onChange(of: viewModel.formBData.textInput) { _ in
                    viewModel.errorMessage = nil
                    // 4桁を超える入力を防ぐ
                    if viewModel.formBData.textInput.count > 4 {
                        viewModel.formBData.textInput = String(viewModel.formBData.textInput.prefix(4))
                    }
                }
            
            Text("4桁の数字で入力してください")
                .foregroundColor(isValidInput ? .green : .red)
                .font(.caption)
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("特別な入力値:")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text("・0000 → 再度フォームBを表示")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text("・9999 → エラー画面を表示")
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
            let result = await viewModel.validateFormB()
            
            await MainActor.run {
                switch result {
                case .valid:
                    if let nextRoute = availableRoutes.first {
                        router.navigate(to: nextRoute, data: viewModel.formBData)
                    }
                case .invalid(let message):
                    viewModel.errorMessage = message
                case .error:
                    viewModel.formBData.errorMessage = "入力されたパスワードが無効です。\n別のパスワードを入力してください。"
                    router.navigate(to: .error, data: viewModel.formBData)
                }
            }
        }
    }
}
