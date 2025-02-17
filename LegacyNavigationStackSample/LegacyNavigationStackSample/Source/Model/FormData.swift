import Foundation

class FormData: ObservableObject {
    @Published var textInput: String = ""
    @Published var selection: Int = 0
    var errorMessage: String = ""
} 