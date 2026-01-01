import SwiftUI

public enum AppButtonSize: CaseIterable {
    case small
    case medium
    case large

    var metrics: AppButtonMetrics {
        switch self {
        case .small:
            return AppButtonMetrics(height: 32,
                                    horizontalPadding: AppSpacing.small.rawValue,
                                    radius: AppRadius.small.rawValue,
                                    font: .app(.subheadline, weight: .semibold))
        case .medium:
            return AppButtonMetrics(height: 44,
                                    horizontalPadding: AppSpacing.medium.rawValue,
                                    radius: AppRadius.medium.rawValue,
                                    font: .app(.headline, weight: .semibold))
        case .large:
            return AppButtonMetrics(height: 52,
                                    horizontalPadding: AppSpacing.large.rawValue,
                                    radius: AppRadius.large.rawValue,
                                    font: .app(.headline, weight: .bold))
        }
    }
}

public struct AppButtonMetrics {
    let height: CGFloat
    let horizontalPadding: CGFloat
    let radius: CGFloat
    let font: Font
}

public struct PrimaryButtonStyle: ButtonStyle {
    public let size: AppButtonSize
    public let isLoading: Bool

    public init(size: AppButtonSize = .medium, isLoading: Bool = false) {
        self.size = size
        self.isLoading = isLoading
    }

    public func makeBody(configuration: Configuration) -> some View {
        AppButtonStyleView(configuration: configuration,
                           size: size,
                           isLoading: isLoading,
                           background: Color.app(.primary),
                           foreground: Color.app(.textPrimary),
                           border: nil,
                           pressedOverlay: Color.black.opacity(0.08))
    }
}

public struct SecondaryButtonStyle: ButtonStyle {
    public let size: AppButtonSize
    public let isLoading: Bool

    public init(size: AppButtonSize = .medium, isLoading: Bool = false) {
        self.size = size
        self.isLoading = isLoading
    }

    public func makeBody(configuration: Configuration) -> some View {
        AppButtonStyleView(configuration: configuration,
                           size: size,
                           isLoading: isLoading,
                           background: Color.clear,
                           foreground: Color.app(.primary),
                           border: Color.app(.border),
                           pressedOverlay: Color.app(.primary).opacity(0.08))
    }
}

public struct TertiaryButtonStyle: ButtonStyle {
    public let size: AppButtonSize
    public let isLoading: Bool

    public init(size: AppButtonSize = .medium, isLoading: Bool = false) {
        self.size = size
        self.isLoading = isLoading
    }

    public func makeBody(configuration: Configuration) -> some View {
        AppButtonStyleView(configuration: configuration,
                           size: size,
                           isLoading: isLoading,
                           background: Color.clear,
                           foreground: Color.app(.primary),
                           border: nil,
                           pressedOverlay: Color.app(.primary).opacity(0.12),
                           hasBackground: false)
    }
}

public struct DestructiveButtonStyle: ButtonStyle {
    public let size: AppButtonSize
    public let isLoading: Bool

    public init(size: AppButtonSize = .medium, isLoading: Bool = false) {
        self.size = size
        self.isLoading = isLoading
    }

    public func makeBody(configuration: Configuration) -> some View {
        AppButtonStyleView(configuration: configuration,
                           size: size,
                           isLoading: isLoading,
                           background: Color.app(.error),
                           foreground: Color.app(.backgroundPrimary),
                           border: nil,
                           pressedOverlay: Color.black.opacity(0.12))
    }
}

private struct AppButtonStyleView: View {
    @Environment(\.isEnabled) private var isEnabled

    let configuration: ButtonStyle.Configuration
    let size: AppButtonSize
    let isLoading: Bool
    let background: Color
    let foreground: Color
    let border: Color?
    let pressedOverlay: Color
    var hasBackground: Bool = true

    var body: some View {
        let metrics = size.metrics
        configuration.label
            .font(metrics.font)
            .foregroundColor(isEnabled ? foreground : Color.app(.textDisabled))
            .frame(maxWidth: .infinity, minHeight: metrics.height)
            .padding(.horizontal, metrics.horizontalPadding)
            .background(hasBackground ? background.opacity(isEnabled ? 1 : 0.4) : Color.clear)
            .overlay(borderOverlay(cornerRadius: metrics.radius))
            .overlay(pressedOverlayView(cornerRadius: metrics.radius))
            .overlay(loadingOverlay)
            .opacity(isLoading ? 0.6 : 1)
            .cornerRadius(metrics.radius)
            .accessibilityElement(children: .combine)
    }

    private func borderOverlay(cornerRadius: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .stroke(border ?? Color.clear, lineWidth: border == nil ? 0 : 1)
    }

    private func pressedOverlayView(cornerRadius: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(configuration.isPressed ? pressedOverlay : Color.clear)
    }

    private var loadingOverlay: some View {
        Group {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: foreground))
            }
        }
    }
}

public extension ButtonStyle where Self == PrimaryButtonStyle {
    static func appPrimary(size: AppButtonSize = .medium, isLoading: Bool = false) -> PrimaryButtonStyle {
        PrimaryButtonStyle(size: size, isLoading: isLoading)
    }
}

public extension ButtonStyle where Self == SecondaryButtonStyle {
    static func appSecondary(size: AppButtonSize = .medium, isLoading: Bool = false) -> SecondaryButtonStyle {
        SecondaryButtonStyle(size: size, isLoading: isLoading)
    }
}

public extension ButtonStyle where Self == TertiaryButtonStyle {
    static func appTertiary(size: AppButtonSize = .medium, isLoading: Bool = false) -> TertiaryButtonStyle {
        TertiaryButtonStyle(size: size, isLoading: isLoading)
    }
}

public extension ButtonStyle where Self == DestructiveButtonStyle {
    static func appDestructive(size: AppButtonSize = .medium, isLoading: Bool = false) -> DestructiveButtonStyle {
        DestructiveButtonStyle(size: size, isLoading: isLoading)
    }
}

#if DEBUG
struct ButtonStyles_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: AppSpacing.small.rawValue) {
            Button("Primary") {}
                .buttonStyle(.appPrimary())
            Button("Secondary") {}
                .buttonStyle(.appSecondary())
            Button("Tertiary") {}
                .buttonStyle(.appTertiary())
            Button("Destructive") {}
                .buttonStyle(.appDestructive())

            Button("Loading") {}
                .buttonStyle(.appPrimary(isLoading: true))

            Button {
            } label: {
                Label("With Icon", systemImage: "star.fill")
            }
            .buttonStyle(.appPrimary(size: .large))
        }
        .appPadding(AppSpacing.medium)
        .previewDisplayName("Button Styles")
    }
}
#endif
