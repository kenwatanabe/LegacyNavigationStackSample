import SwiftUI

enum TransitionDirection {
    case forward
    case backward
    case modal
    case none
}

struct SlideTransition: ViewModifier {
    let direction: TransitionDirection
    let isActive: Bool
    
    func body(content: Content) -> some View {
        content
            .transition(.asymmetric(
                insertion: .move(edge: direction == .forward ? .trailing : .leading),
                removal: .move(edge: direction == .forward ? .leading : .trailing)
            ))
    }
}

struct NavigationContainer: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var viewModel: SharedFormViewModel
    @StateObject private var flowManager = FlowManager()
    
    var body: some View {
        NavigationView {
            ZStack {
                // 現在のルートに基づいて、エラー以外の画面を表示
                if router.currentRoute != .error {
                    NavHost(route: router.currentRoute)
                        .environmentObject(flowManager)
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
            return .asymmetric(
                insertion: .move(edge: .trailing),
                removal: .move(edge: .leading)
            )
        case .backward:
            return .asymmetric(
                insertion: .move(edge: .leading),
                removal: .move(edge: .trailing)
            )
        case .modal, .none:
            return .identity
        }
    }
}
