import SwiftUI

public enum AppCardVariant: CaseIterable {
    case flat
    case elevated
    case outlined
}

public struct AppCard<Content: View>: View {
    private let variant: AppCardVariant
    private let padding: AppSpacing.Value
    private let cornerRadius: AppRadius.Value
    private let background: Color
    private let content: Content

    public init(variant: AppCardVariant = .elevated,
                padding: AppSpacing.Value = AppSpacing.medium,
                cornerRadius: AppRadius.Value = AppRadius.large,
                background: Color = .app(.backgroundSecondary),
                @ViewBuilder content: () -> Content) {
        self.variant = variant
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.background = background
        self.content = content()
    }

    public var body: some View {
        content
            .appPadding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(background)
            .overlay(outlineOverlay)
            .appCornerRadius(cornerRadius)
            .appShadow(shadowStyle)
            .accessibilityElement(children: .contain)
    }

    private var shadowStyle: AppShadow.Style {
        switch variant {
        case .flat, .outlined:
            return .small
        case .elevated:
            return .medium
        }
    }

    private var outlineOverlay: some View {
        RoundedRectangle(cornerRadius: cornerRadius.rawValue)
            .stroke(variant == .outlined ? Color.app(.border) : Color.clear, lineWidth: 1)
    }
}

#if DEBUG
struct AppCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: AppSpacing.medium.rawValue) {
            AppCard(variant: .flat) {
                Text("Flat card")
                    .font(.app(.headline))
            }

            AppCard(variant: .outlined) {
                Text("Outlined card")
                    .font(.app(.headline))
            }

            AppCard(variant: .elevated) {
                Text("Elevated card")
                    .font(.app(.headline))
            }
        }
        .appPadding(AppSpacing.medium)
        .previewDisplayName("AppCard")
    }
}
#endif
