import SwiftUI

/// ホーム画面のView
/// 利用可能なフローの一覧を表示し、選択されたフローを開始する
struct HomeView: View {
    @EnvironmentObject var router: Router // 画面遷移
    @EnvironmentObject var flowManager: FlowManager // フロー管理
    
    var body: some View {
        VStack(spacing: 20) {
            // タイトル
            Text("フローを選択してください")
                .font(.title)
            
            // 利用可能なフローの一覧をボタンとして表示
            ForEach(Array(flowManager.availableFlows.enumerated()), id: \.element.id) { _, flow in
                Button(action: {
                    // フローの選択と開始画面への遷移
                    flowManager.selectFlow(flow.id)
                    router.navigate(to: flow.startRoute)
                }) {
                    // フロー情報の表示
                    VStack {
                        // フローのタイトル
                        Text(flow.title)
                            .font(.headline)
                        // フローの説明文
                        Text(flow.description)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                }
            }
        }
        .padding()
    }
}
