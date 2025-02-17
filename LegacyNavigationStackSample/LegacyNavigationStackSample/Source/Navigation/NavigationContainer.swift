import SwiftUI

enum TransitionDirection {
    case forward   // 前方への遷移（新しい画面へ）
    case backward  // 後方への遷移（前の画面へ）
    case modal     // モーダル表示での遷移
    case none      // 遷移アニメーションなし
}

struct SlideTransition: ViewModifier {
    let direction: TransitionDirection
    let isActive: Bool
    
    func body(content: Content) -> some View {
        content
            .transition(.asymmetric(
                // 前方遷移時は右から、後方遷移時は左からスライドイン
                insertion: .move(edge: direction == .forward ? .trailing : .leading),
                // 前方遷移時は左へ、後方遷移時は右へスライドアウト
                removal: .move(edge: direction == .forward ? .leading : .trailing)
            ))
    }
}

struct NavigationContainer: View {
    @EnvironmentObject var router: Router
    // フォームデータを共有するViewModel
    @EnvironmentObject var viewModel: SharedFormViewModel
    @StateObject private var flowManager = FlowManager()
    
    var body: some View {
        NavigationView {
            ZStack {
                // 現在のルートに基づいて、エラー以外の画面を表示
                if router.currentRoute != .error {
                    NavHost(route: router.currentRoute)
                        .environmentObject(flowManager)
                        // カスタム遷移アニメーションを適用
                        .transition(standardTransitionAnimation)
                        .animation(router.transitionDirection == .none ? nil : .easeInOut(duration: 0.3), value: router.currentRoute)
                }
                
                // エラー画面を別レイヤーとして表示
                if router.currentRoute == .error {
                    NavHost(route: .error)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(.easeInOut(duration: 0.3), value: router.currentRoute)
                }
            }
            .navigationTitle(router.currentRoute.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                // 左側の戻るボタン（ホーム画面とエラー画面以外で表示）
                ToolbarItem(placement: .navigationBarLeading) {
                    if router.currentRoute != .home && router.currentRoute != .error {
                        Button(action: {
                            router.navigateBack(viewModel: viewModel)
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("戻る")
                            }
                            .foregroundColor(.primary)
                        }
                    }
                }
                
                // 右側の閉じるボタン（ホーム画面とエラー画面以外で表示）
                ToolbarItem(placement: .navigationBarTrailing) {
                    if router.currentRoute != .home && router.currentRoute != .error {
                        Button(action: {
                            router.navigateToRoot()
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            // ナビゲーションバーの背景色を設定
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemBackground
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            
            // 標準のナビゲーションバーの外観を設定
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    private var standardTransitionAnimation: AnyTransition {
        switch router.transitionDirection {
        case .forward:
            // 前方遷移時のアニメーション（右からスライドイン + フェード）
            return .asymmetric(
                insertion: .move(edge: .trailing).combined(with: .opacity.animation(.easeIn)),
                removal: .move(edge: .leading).combined(with: .opacity.animation(.easeOut))
            )
        case .backward:
            // 後方遷移時のアニメーション（左からスライドイン + フェード）
            return .asymmetric(
                insertion: .move(edge: .leading).combined(with: .opacity.animation(.easeIn)),
                removal: .move(edge: .trailing).combined(with: .opacity.animation(.easeOut))
            )
        case .modal, .none:
            return .identity
        }
    }
}
