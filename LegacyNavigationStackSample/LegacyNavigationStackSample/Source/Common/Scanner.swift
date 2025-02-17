import Foundation

protocol Scanner {
    associatedtype Value
    func scan(_ value: Value) async -> ScanResult
}

struct FormAScanner: Scanner {
    func scan(_ value: String) async -> ScanResult {
        // スキャンをシミュレート
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        let text = value.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 実際のスキャン処理はこの辺り
        
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

struct FormBScanner: Scanner {
    func scan(_ value: String) async -> ScanResult {
        // スキャンをシミュレート
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        let text = value.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 実際のスキャン処理はこの辺り
        
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
