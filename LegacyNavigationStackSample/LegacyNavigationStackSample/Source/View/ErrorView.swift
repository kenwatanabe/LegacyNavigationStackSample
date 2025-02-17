import SwiftUI

struct ErrorView: View {
    @EnvironmentObject var router: Router
    let errorMessage: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50))
                .foregroundColor(.red)
            
            Text("エラーが発生しました")
                .font(.title)
            
            Text(errorMessage)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding()
            
            Button(action: {
                router.navigateToRoot()
            }) {
                Text("ホームに戻る")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .padding()
    }
} 