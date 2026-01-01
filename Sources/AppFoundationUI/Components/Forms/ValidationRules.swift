import Foundation

public protocol ValidationRule {
    func validate(_ value: String) -> ValidationResult
}

public enum ValidationResult: Equatable {
    case success
    case failure(message: String)
}

public enum ValidationRules {
    public struct Required: ValidationRule {
        public let message: String
        public init(message: String = "This field is required") { self.message = message }
        public func validate(_ value: String) -> ValidationResult {
            value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .failure(message: message) : .success
        }
    }

    public struct Email: ValidationRule {
        public let message: String
        public init(message: String = "Enter a valid email") { self.message = message }
        public func validate(_ value: String) -> ValidationResult {
            let pattern = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$"
            let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
            let range = NSRange(location: 0, length: value.utf16.count)
            if regex?.firstMatch(in: value, options: [], range: range) != nil {
                return .success
            }
            return .failure(message: message)
        }
    }

    public struct MinLength: ValidationRule {
        public let min: Int
        public let message: String
        public init(_ min: Int, message: String? = nil) {
            self.min = min
            self.message = message ?? "Must be at least \(min) characters"
        }
        public func validate(_ value: String) -> ValidationResult {
            value.count < min ? .failure(message: message) : .success
        }
    }

    public struct MaxLength: ValidationRule {
        public let max: Int
        public let message: String
        public init(_ max: Int, message: String? = nil) {
            self.max = max
            self.message = message ?? "Must be \(max) characters or fewer"
        }
        public func validate(_ value: String) -> ValidationResult {
            value.count > max ? .failure(message: message) : .success
        }
    }

    public struct Regex: ValidationRule {
        public let pattern: String
        public let message: String
        public init(_ pattern: String, message: String) {
            self.pattern = pattern
            self.message = message
        }
        public func validate(_ value: String) -> ValidationResult {
            guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { return .success }
            let range = NSRange(location: 0, length: value.utf16.count)
            if regex.firstMatch(in: value, options: [], range: range) != nil {
                return .success
            }
            return .failure(message: message)
        }
    }
}

public enum Validation {
    case custom(ValidationRule)
    case email
    case required
    case minLength(Int)
    case maxLength(Int)
    case regex(String, message: String)
    case none

    public func rule() -> ValidationRule? {
        switch self {
        case .custom(let rule): return rule
        case .email: return ValidationRules.Email()
        case .required: return ValidationRules.Required()
        case .minLength(let min): return ValidationRules.MinLength(min)
        case .maxLength(let max): return ValidationRules.MaxLength(max)
        case .regex(let pattern, let message): return ValidationRules.Regex(pattern, message: message)
        case .none: return nil
        }
    }
}
