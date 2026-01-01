import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

public enum AppTextFieldKeyboard {
    case `default`
    case emailAddress
    case numberPad
    case decimalPad
    case phonePad
}

public enum AppTextFieldContentType {
    case emailAddress
    case password
    case username
    case oneTimeCode
    case newPassword
}

public enum AppTextFieldAutocapitalization {
    case sentences
    case words
    case characters
    case none
}

public struct AppTextField: View {
    @Binding private var text: String
@FocusState private var isFocused: Bool

private let placeholder: String
private let icon: String?
private let trailingIcon: String?
    private let helperText: String?
private let showClear: Bool
private let characterLimit: Int?
private let validation: Validation
private let validator: FormValidating
private let keyboardType: AppTextFieldKeyboard?
private let textContentType: AppTextFieldContentType?
private let autocapitalization: AppTextFieldAutocapitalization?
private let submitLabel: SubmitLabel
private let onSubmit: (() -> Void)?

    @State private var validationResult: ValidationResult?

    public init(text: Binding<String>,
                placeholder: String = "",
                icon: String? = nil,
                trailingIcon: String? = nil,
                helperText: String? = nil,
                showClear: Bool = true,
                characterLimit: Int? = nil,
                validation: Validation = .none,
                validator: FormValidating = FormValidator(),
                keyboardType: AppTextFieldKeyboard? = .default,
                textContentType: AppTextFieldContentType? = nil,
                autocapitalization: AppTextFieldAutocapitalization? = .sentences,
                submitLabel: SubmitLabel = .done,
                onSubmit: (() -> Void)? = nil) {
        self._text = text
        self.placeholder = placeholder
        self.icon = icon
        self.trailingIcon = trailingIcon
        self.helperText = helperText
        self.showClear = showClear
        self.characterLimit = characterLimit
        self.validation = validation
        self.validator = validator
        self.keyboardType = keyboardType
        self.textContentType = textContentType
        self.autocapitalization = autocapitalization
        self.submitLabel = submitLabel
        self.onSubmit = onSubmit
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xSmall.rawValue) {
            HStack(spacing: AppSpacing.xSmall.rawValue) {
                if let icon {
                    Image(systemName: icon)
                        .foregroundColor(.app(.textSecondary))
                        .accessibilityHidden(true)
                }

                TextField(placeholder, text: $text)
                    .modifier(KeyboardConfiguration(keyboardType: keyboardType,
                                                    textContentType: textContentType,
                                                    autocapitalization: autocapitalization,
                                                    submitLabel: submitLabel,
                                                    isFocused: $isFocused,
                                                    onSubmit: {
                        validate()
                        onSubmit?()
                    }))
                    .onChange(of: text) { newValue in
                        applyLimitIfNeeded(newValue)
                        validate()
                    }

                if let trailingIcon {
                    Image(systemName: trailingIcon)
                        .foregroundColor(.app(.textSecondary))
                        .accessibilityHidden(true)
                }

                if showClear && !text.isEmpty {
                    Button {
                        text = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.app(.textTertiary))
                    }
                    .accessibilityLabel("Clear text")
                }
            }
            .padding(.horizontal, AppSpacing.small.rawValue)
            .padding(.vertical, AppSpacing.xSmall.rawValue)
            .background(fieldBackground)
            .overlay(borderOverlay)
            .cornerRadius(AppRadius.medium.rawValue)

            if let helperText, validationResult?.failureMessage == nil {
                Text(helperText)
                    .font(.app(.caption))
                    .foregroundColor(.app(.textSecondary))
            }

            validationMessage(validationResult)
            characterCounter
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(placeholder)
    }

    private var fieldBackground: Color {
        Color.app(.backgroundSecondary)
    }

    private var borderOverlay: some View {
        RoundedRectangle(cornerRadius: AppRadius.medium.rawValue)
            .stroke(borderColor, lineWidth: 1)
    }

    private var borderColor: Color {
        if isFocused { return .app(.primary) }
        if validationResult?.isFailure == true { return .app(.error) }
        return .app(.border)
    }

    private var characterCounter: some View {
        Group {
            if let characterLimit {
                HStack {
                    Spacer()
                    Text("\(text.count)/\(characterLimit)")
                        .font(.app(.caption))
                        .foregroundColor(.app(.textSecondary))
                        .accessibilityLabel("\(text.count) of \(characterLimit) characters")
                }
            }
        }
    }

    private func applyLimitIfNeeded(_ newValue: String) {
        guard let limit = characterLimit else { return }
        if newValue.count > limit {
            text = String(newValue.prefix(limit))
        }
    }

    private func validate() {
        validationResult = validator.validate(text, using: validation)
    }
}

private extension ValidationResult {
    var isFailure: Bool {
        if case .failure = self { return true }
        return false
    }
    var failureMessage: String? {
        if case .failure(let message) = self { return message }
        return nil
    }
}

private struct KeyboardConfiguration: ViewModifier {
    let keyboardType: AppTextFieldKeyboard?
    let textContentType: AppTextFieldContentType?
    let autocapitalization: AppTextFieldAutocapitalization?
    let submitLabel: SubmitLabel
    var isFocused: FocusState<Bool>.Binding
    let onSubmit: () -> Void

    func body(content: Content) -> some View {
        var view = content
            .submitLabel(submitLabel)
            .focused(isFocused)
            .onSubmit(onSubmit)
        #if canImport(UIKit)
        if let keyboardType { view = view.keyboardType(keyboardType.uiType) }
        if let textContentType { view = view.textContentType(textContentType.uiContentType) }
        if let autocapitalization { view = view.textInputAutocapitalization(autocapitalization.uiCapitalization) }
        #endif
        return view
    }
}

#if canImport(UIKit)
private extension AppTextFieldKeyboard {
    var uiType: UIKeyboardType {
        switch self {
        case .default: return .default
        case .emailAddress: return .emailAddress
        case .numberPad: return .numberPad
        case .decimalPad: return .decimalPad
        case .phonePad: return .phonePad
        }
    }
}

private extension AppTextFieldContentType {
    var uiContentType: UITextContentType {
        switch self {
        case .emailAddress: return .emailAddress
        case .password: return .password
        case .username: return .username
        case .oneTimeCode: return .oneTimeCode
        case .newPassword: return .newPassword
        }
    }
}

private extension AppTextFieldAutocapitalization {
    var uiCapitalization: TextInputAutocapitalization {
        switch self {
        case .sentences: return .sentences
        case .words: return .words
        case .characters: return .characters
        case .none: return .never
        }
    }
}
#endif

#if DEBUG
struct AppTextField_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: AppSpacing.medium.rawValue) {
            AppTextField(text: Binding.constant(""), placeholder: "Email", icon: "envelope", validation: .email)
            AppTextField(text: Binding.constant("Hello"), placeholder: "Name", helperText: "Enter your full name")
            AppTextField(text: Binding.constant("Too long text"), placeholder: "Limited", characterLimit: 10)
            AppTextField(text: Binding.constant(""), placeholder: "With error", validation: .required)
        }
        .appPadding(AppSpacing.medium)
        .previewDisplayName("AppTextField")
    }
}
#endif
