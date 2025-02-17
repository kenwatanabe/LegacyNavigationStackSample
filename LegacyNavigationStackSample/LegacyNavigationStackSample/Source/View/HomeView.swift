import SwiftUI

struct HomeView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var flowManager: FlowManager
    
    var body: some View {
        VStack(spacing: 20) {
            Text("フローを選択してください")
                .font(.title)
            
            ForEach(Array(flowManager.availableFlows.enumerated()), id: \.element.id) { _, flow in
                Button(action: {
                    flowManager.selectFlow(flow.id)
                    router.navigate(to: flow.startRoute)
                }) {
                    VStack {
                        Text(flow.title)
                            .font(.headline)
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
