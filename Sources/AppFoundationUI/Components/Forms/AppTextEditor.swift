import SwiftUI

public struct AppTextEditor: View {
    @Binding private var text: String
    @FocusState private var isFocused: Bool

    private let placeholder: String
    private let characterLimit: Int?
    private let showCounter: Bool
    private let autoGrow: Bool
    private let minHeight: CGFloat
    private let toolbarDone: Bool
    private let validation: Validation
    private let validator: FormValidating

    @State private var validationResult: ValidationResult?

    public init(text: Binding<String>,
                placeholder: String = "",
                characterLimit: Int? = nil,
                showCounter: Bool = true,
                autoGrow: Bool = true,
                minHeight: CGFloat = 120,
                toolbarDone: Bool = true,
                validation: Validation = .none,
                validator: FormValidating = FormValidator()) {
        self._text = text
        self.placeholder = placeholder
        self.characterLimit = characterLimit
        self.showCounter = showCounter
        self.autoGrow = autoGrow
        self.minHeight = minHeight
        self.toolbarDone = toolbarDone
        self.validation = validation
        self.validator = validator
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xSmall.rawValue) {
            ZStack(alignment: .topLeading) {
                TextEditor(text: $text)
                    .focused($isFocused)
                    .frame(minHeight: minHeight, maxHeight: autoGrow ? .infinity : minHeight)
                    .padding(AppSpacing.xSmall.rawValue)
                    .background(Color.app(.backgroundSecondary))
                    .overlay(borderOverlay)
                    .cornerRadius(AppRadius.medium.rawValue)
                    .onChange(of: text) { newValue in
                        applyLimitIfNeeded(newValue)
                        validate()
                    }
                    #if canImport(UIKit)
                    .toolbar {
                        if toolbarDone {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Done") { isFocused = false }
                                    .font(.app(.body, weight: .semibold))
                            }
                        }
                    }
                    #endif

                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(.app(.textTertiary))
                        .padding(AppSpacing.small.rawValue)
                        .accessibilityHidden(true)
                }
            }

            if showCounter, let limit = characterLimit {
                HStack {
                    Spacer()
                    Text("\(text.count)/\(limit)")
                        .font(.app(.caption))
                        .foregroundColor(.app(.textSecondary))
                        .accessibilityLabel("\(text.count) of \(limit) characters")
                }
            }

            validationMessage(validationResult)
        }
        .onAppear { validate() }
        .accessibilityLabel(placeholder)
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
}

#if DEBUG
struct AppTextEditor_Previews: PreviewProvider {
    static var previews: some View {
        AppTextEditor(text: .constant(""),
                      placeholder: "Tell us about yourself",
                      characterLimit: 120)
        .appPadding(AppSpacing.medium)
        .previewDisplayName("AppTextEditor")
    }
}
#endif
