import Foundation

enum ScanResult {
    case valid
    case invalid(String) // エラーメッセージを含む
    case error
} 
