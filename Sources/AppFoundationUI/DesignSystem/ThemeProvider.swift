import SwiftUI

/// Theme provider enables app-specific customization of the design system.
///
/// Usage:
/// ```swift
/// struct MyTheme: ThemeProvider { ... }
///
/// ContentView()
///     .appTheme(MyTheme())
/// ```
public protocol ThemeProvider: Sendable {
    func color(_ token: AppColors.Token) -> Color
    func font(_ style: AppFonts.TextStyle, weight: AppFonts.Weight) -> Font
    func spacing(_ value: AppSpacing.Value) -> CGFloat
    func radius(_ value: AppRadius.Value) -> CGFloat
    func shadow(_ style: AppShadow.Style) -> AppShadow.Elevation
}

/// Default theme implementation using AppFoundationUI system values.
public struct DefaultThemeProvider: ThemeProvider {
    public init() {}

    public func color(_ token: AppColors.Token) -> Color {
        AppColors.color(token)
    }

    public func font(_ style: AppFonts.TextStyle, weight: AppFonts.Weight) -> Font {
        AppFonts.font(style, weight: weight)
    }

    public func spacing(_ value: AppSpacing.Value) -> CGFloat {
        value.rawValue
    }

    public func radius(_ value: AppRadius.Value) -> CGFloat {
        value.rawValue
    }

    public func shadow(_ style: AppShadow.Style) -> AppShadow.Elevation {
        AppShadow.elevation(style)
    }
}

private struct AppThemeKey: EnvironmentKey {
    static let defaultValue: any ThemeProvider = DefaultThemeProvider()
}

public extension EnvironmentValues {
    var appTheme: any ThemeProvider {
        get { self[AppThemeKey.self] }
        set { self[AppThemeKey.self] = newValue }
    }
}

public extension View {
    /// Inject a theme for descendants.
    func appTheme(_ theme: any ThemeProvider) -> some View {
        environment(\.appTheme, theme)
    }

    /// Apply a themed foreground color.
    func appForegroundColor(_ token: AppColors.Token) -> some View {
        modifier(AppForegroundColorModifier(token: token))
    }

    /// Apply a themed background color.
    func appBackground(_ token: AppColors.Token) -> some View {
        modifier(AppBackgroundModifier(token: token))
    }

    /// Apply a themed font.
    func appFont(_ style: AppFonts.TextStyle, weight: AppFonts.Weight = .regular) -> some View {
        modifier(AppFontModifier(style: style, weight: weight))
    }

    /// Apply a themed padding value.
    func appPadding(_ value: AppSpacing.Value, edges: Edge.Set = .all) -> some View {
        modifier(AppPaddingModifier(value: value, edges: edges))
    }

    /// Apply a themed corner radius.
    func appCornerRadius(_ value: AppRadius.Value) -> some View {
        modifier(AppCornerRadiusModifier(value: value))
    }

    /// Apply a themed shadow.
    func appShadow(_ style: AppShadow.Style) -> some View {
        modifier(AppShadowModifier(style: style))
    }
}

private struct AppForegroundColorModifier: ViewModifier {
    @Environment(\.appTheme) private var theme
    let token: AppColors.Token

    func body(content: Content) -> some View {
        content.foregroundColor(theme.color(token))
    }
}

private struct AppBackgroundModifier: ViewModifier {
    @Environment(\.appTheme) private var theme
    let token: AppColors.Token

    func body(content: Content) -> some View {
        content.background(theme.color(token))
    }
}

private struct AppFontModifier: ViewModifier {
    @Environment(\.appTheme) private var theme
    let style: AppFonts.TextStyle
    let weight: AppFonts.Weight

    func body(content: Content) -> some View {
        content.font(theme.font(style, weight: weight))
    }
}

private struct AppPaddingModifier: ViewModifier {
    @Environment(\.appTheme) private var theme
    let value: AppSpacing.Value
    let edges: Edge.Set

    func body(content: Content) -> some View {
        content.padding(edges, theme.spacing(value))
    }
}

private struct AppCornerRadiusModifier: ViewModifier {
    @Environment(\.appTheme) private var theme
    let value: AppRadius.Value

    func body(content: Content) -> some View {
        content.cornerRadius(theme.radius(value))
    }
}

private struct AppShadowModifier: ViewModifier {
    @Environment(\.appTheme) private var theme
    let style: AppShadow.Style

    func body(content: Content) -> some View {
        let elevation = theme.shadow(style)
        return content.shadow(color: elevation.color,
                              radius: elevation.radius,
                              x: elevation.x,
                              y: elevation.y)
    }
}

#if DEBUG
struct ThemeProvider_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Themed Title")
                .appFont(.title, weight: .bold)
                .appForegroundColor(.textPrimary)
            Text("Supporting text using themed styles.")
                .appFont(.body)
                .appForegroundColor(.textSecondary)
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.app(.primary))
                .frame(height: 48)
                .appShadow(.medium)
        }
        .appPadding(AppSpacing.medium)
        .appBackground(.backgroundPrimary)
        .previewDisplayName("Theme Provider")
    }
}
#endif
