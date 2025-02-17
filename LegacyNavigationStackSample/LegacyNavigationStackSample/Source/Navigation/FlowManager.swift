import SwiftUI

class FlowManager: ObservableObject {
    @Published var currentFlow: NavigationFlow
    @Published var availableFlows: [NavigationFlow]
    
    init() {
        let flows = [
            NavigationFlow.routeA,
            NavigationFlow.routeB,
            NavigationFlow.routeC,
            NavigationFlow.routeD
        ]
        self.availableFlows = flows
        self.currentFlow = flows[0]
    }
    
    func getNextRoutes(from currentRoute: AppRoute) -> [AppRoute] {
        return currentFlow.transitions[currentRoute] ?? []
    }
    
    func selectFlow(_ flowId: String) {
        if let flow = availableFlows.first(where: { $0.id == flowId }) {
            currentFlow = flow
        }
    }
} 
