import Foundation

enum ValidationResult {
    case valid
    case invalid(String) // エラーメッセージを含む
    case error
} 