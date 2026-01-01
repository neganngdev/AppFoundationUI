import SwiftUI

public struct FormField<Value>: Identifiable {
    public let id = UUID()
    public var value: Value
    public var validation: Validation
    public var error: String?

    public init(value: Value, validation: Validation = .none, error: String? = nil) {
        self.value = value
        self.validation = validation
        self.error = error
    }
}

public protocol FormValidating {
    func validate(_ text: String, using validation: Validation) -> ValidationResult
}

public struct FormValidator: FormValidating {
    public init() {}

    public func validate(_ text: String, using validation: Validation) -> ValidationResult {
        guard let rule = validation.rule() else { return .success }
        return rule.validate(text)
    }
}

public extension View {
    @ViewBuilder
    func validationMessage(_ result: ValidationResult?, errorColor: Color = .app(.error)) -> some View {
        if case .failure(let message) = result {
            Text(message)
                .font(.app(.caption))
                .foregroundColor(errorColor)
                .accessibilityLabel("Error: \(message)")
        }
    }
}
