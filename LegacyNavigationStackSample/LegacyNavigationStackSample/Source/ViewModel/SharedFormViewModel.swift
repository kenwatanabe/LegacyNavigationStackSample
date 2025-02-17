import SwiftUI

/// フォームA、Bのデータと状態を共有・管理するViewModel
class SharedFormViewModel: ObservableObject {
    @Published var formAData = FormData()
    @Published var formBData = FormData()
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    private let formAScanner = FormAScanner()
    private let formBScanner = FormBScanner()
    
    func scanFormA() async -> ScanResult {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        // 入力値の検証
        let result = await formAScanner.scan(formAData.textInput)
        
        await MainActor.run {
            isLoading = false
        }
        
        return result
    }
    
    func scanFormB() async -> ScanResult {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        // 入力値の検証
        let result = await formBScanner.scan(formBData.textInput)
        
        await MainActor.run {
            isLoading = false
        }
        
        return result
    }
    
    /// すべての状態をリセットする
    /// フォームデータ、エラーメッセージ、ローディング状態を初期状態に戻す
    func reset() {
        formAData = FormData()
        formBData = FormData()
        errorMessage = nil
        isLoading = false
    }
}
