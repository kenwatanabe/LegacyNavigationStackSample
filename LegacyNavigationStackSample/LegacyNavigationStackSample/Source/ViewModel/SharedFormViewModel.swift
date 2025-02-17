import SwiftUI

class SharedFormViewModel: ObservableObject {
    @Published var formAData = FormData()
    @Published var formBData = FormData()
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    private let formAValidator = FormAValidator()
    private let formBValidator = FormBValidator()
    
    func validateFormA() async -> ValidationResult {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        let result = await formAValidator.validate(formAData.textInput)
        
        await MainActor.run {
            isLoading = false
        }
        
        return result
    }
    
    func validateFormB() async -> ValidationResult {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        let result = await formBValidator.validate(formBData.textInput)
        
        await MainActor.run {
            isLoading = false
        }
        
        return result
    }
    
    func reset() {
        formAData = FormData()
        formBData = FormData()
        errorMessage = nil
        isLoading = false
    }
} 
