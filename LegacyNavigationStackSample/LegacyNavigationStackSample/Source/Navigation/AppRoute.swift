import SwiftUI

enum AppRoute: Route, Equatable {
    case home
    case tutorial
    case aForm
    case bForm
    case textPreview
    case result
    case error
    
    @ViewBuilder
    var view: some View {
        EmptyView()
    }
    
    var navigationTitle: String {
        switch self {
        case .home:
            return "ホーム"
        case .tutorial:
            return "チュートリアル"
        case .aForm:
            return "フォームA"
        case .bForm:
            return "フォームB"
        case .textPreview:
            return "プレビュー"
        case .result:
            return "結果"
        case .error:
            return "エラー"
        }
    }
}

extension AppRoute {
    var buttonTitle: String {
        switch self {
        case .home:
            return "ホームへ"
        case .tutorial:
            return "チュートリアルへ"
        case .aForm:
            return "フォームAへ"
        case .bForm:
            return "フォームBへ"
        case .textPreview:
            return "プレビューへ"
        case .result:
            return "結果へ"
        case .error:
            return "エラー"
        }
    }
}
