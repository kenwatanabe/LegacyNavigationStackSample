import SwiftUI

struct ResultView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var viewModel: SharedFormViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("結果画面")
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
            
            Button(action: {
                router.navigateToRoot()
            }) {
                Text("最初に戻る")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
    }
}

