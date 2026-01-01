import SwiftUI

public enum AppButtonStyleVariant: CaseIterable {
    case primary
    case secondary
    case tertiary
    case destructive
}

public struct AppButton: View {
    private let title: String
    private let systemImage: String?
    private let style: AppButtonStyleVariant
    private let size: AppButtonSize
    private let isLoading: Bool
    private let action: () -> Void

    public init(_ title: String,
                systemImage: String? = nil,
                style: AppButtonStyleVariant = .primary,
                size: AppButtonSize = .medium,
                isLoading: Bool = false,
                action: @escaping () -> Void) {
        self.title = title
        self.systemImage = systemImage
        self.style = style
        self.size = size
        self.isLoading = isLoading
        self.action = action
    }

    public var body: some View {
        styledButton()
    }

    private func styledButton() -> some View {
        let label = Group {
            if let systemImage {
                Label(title, systemImage: systemImage)
                    .labelStyle(.titleAndIcon)
            } else {
                Text(title)
            }
        }

        switch style {
        case .primary:
            return AnyView(Button(action: action) { label }
                .buttonStyle(.appPrimary(size: size, isLoading: isLoading))
                .disabled(isLoading)
                .accessibilityHint(isLoading ? "Loading" : ""))
        case .secondary:
            return AnyView(Button(action: action) { label }
                .buttonStyle(.appSecondary(size: size, isLoading: isLoading))
                .disabled(isLoading)
                .accessibilityHint(isLoading ? "Loading" : ""))
        case .tertiary:
            return AnyView(Button(action: action) { label }
                .buttonStyle(.appTertiary(size: size, isLoading: isLoading))
                .disabled(isLoading)
                .accessibilityHint(isLoading ? "Loading" : ""))
        case .destructive:
            return AnyView(Button(action: action) { label }
                .buttonStyle(.appDestructive(size: size, isLoading: isLoading))
                .disabled(isLoading)
                .accessibilityHint(isLoading ? "Loading" : ""))
        }
    }
}

#if DEBUG
struct AppButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: AppSpacing.small.rawValue) {
            AppButton("Primary") {}
            AppButton("Secondary", style: .secondary) {}
            AppButton("Tertiary", style: .tertiary) {}
            AppButton("Delete", style: .destructive) {}
            AppButton("Loading", isLoading: true) {}
            AppButton("With Icon", systemImage: "paperplane.fill", size: .large) {}
        }
        .appPadding(AppSpacing.medium)
        .previewDisplayName("AppButton")
    }
}
#endif
