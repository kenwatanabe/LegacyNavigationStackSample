import Foundation

protocol Validator {
    associatedtype Value
    func validate(_ value: Value) async -> ValidationResult
}

struct FormAValidator: Validator {
    func validate(_ value: String) async -> ValidationResult {
        // APIリクエストをシミュレート
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        let text = value.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 6〜16文字のチェック
        guard text.count >= 6 && text.count <= 16 else {
            return .invalid("6〜16文字で入力してください")
        }
        
        // 英数字のみかチェック
        let alphanumericRegex = "^[a-zA-Z0-9]+$"
        guard text.range(of: alphanumericRegex, options: .regularExpression) != nil else {
            return .invalid("英数字のみ入力可能です")
        }
        
        // 英字を含むかチェック
        let alphabetRegex = "[a-zA-Z]"
        guard text.range(of: alphabetRegex, options: .regularExpression) != nil else {
            return .invalid("アルファベットを1文字以上含めてください")
        }
        
        // 数字を含むかチェック
        let numberRegex = "[0-9]"
        guard text.range(of: numberRegex, options: .regularExpression) != nil else {
            return .invalid("数字を1文字以上含めてください")
        }
        
        // 特定の入力値のチェック
        if text == "111AAA" {
            return .invalid("パスワードに誤りがあります")
        }
        
        if text == "222BBB" {
            return .error
        }
        
        return .valid
    }
}

struct FormBValidator: Validator {
    func validate(_ value: String) async -> ValidationResult {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        let text = value.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 4桁の数字のみかチェック
        let numberRegex = "^[0-9]{4}$"
        guard text.range(of: numberRegex, options: .regularExpression) != nil else {
            return .invalid("4桁の数字で入力してください")
        }
        
        // 特定の入力値のチェック
        switch text {
        case "0000":
            return .invalid("パスワードに誤りがあります")
        case "9999":
            return .error
        default:
            return .valid
        }
    }
}
