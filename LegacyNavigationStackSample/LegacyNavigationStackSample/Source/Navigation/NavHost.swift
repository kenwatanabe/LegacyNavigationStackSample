import SwiftUI

struct NavHost: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var viewModel: SharedFormViewModel
    @StateObject private var flowManager = FlowManager()
    let route: AppRoute
    
    var body: some View {
        Group {
            switch route {
            case .home:
                HomeView()
                    .environmentObject(flowManager)
                    .onAppear {
                        viewModel.reset()
                        router.cleanup()
                    }
            case .tutorial:
                TutorialView(availableRoutes: flowManager.getNextRoutes(from: .tutorial))
            
            case .aForm:
                AFormView(availableRoutes: flowManager.getNextRoutes(from: .aForm))
            
            case .bForm:
                BFormView(
                    availableRoutes: flowManager.getNextRoutes(from: .bForm),
                    previousFormData: router.getCurrentData()
                )
            
            case .textPreview:
                TextPreviewView(
                    availableRoutes: flowManager.getNextRoutes(from: .textPreview),
                    previousFormData: router.getCurrentData()
                )
            
            case .result:
                ResultView()
            case .error:
                ErrorView(errorMessage: router.getCurrentData()?.errorMessage ?? "エラーが発生しました")
            }
        }
    }
}
