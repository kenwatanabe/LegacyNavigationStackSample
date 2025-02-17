import SwiftUI

struct TutorialView: View {
    @EnvironmentObject var router: Router
    let availableRoutes: [AppRoute]
    
    var body: some View {
        VStack {
            Text("チュートリアル")
                .font(.title)
            
            Text("使い方の説明")
                .padding()
            
            ForEach(availableRoutes, id: \.self) { route in
                Button(action: {
                    router.navigate(to: route)
                }) {
                    Text(route.buttonTitle)
                }
                .padding()
            }
        }
    }
}

