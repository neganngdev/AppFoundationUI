import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

/// Centralized color tokens for the design system.
///
/// Usage:
/// ```swift
/// Text("Hello")
///     .foregroundColor(.app(.textPrimary))
/// ```
public struct AppColors {
    public enum Token: CaseIterable {
        case primary
        case secondary
        case accent
        case backgroundPrimary
        case backgroundSecondary
        case backgroundTertiary
        case textPrimary
        case textSecondary
        case textTertiary
        case textDisabled
        case success
        case warning
        case error
        case info
        case border
        case separator
    }

    public static func color(_ token: Token) -> Color {
        switch token {
        case .primary:
            return dynamic(light: PlatformColor(red: 0.04, green: 0.52, blue: 1.00, alpha: 1.0),
                           dark: PlatformColor(red: 0.30, green: 0.62, blue: 1.00, alpha: 1.0))
        case .secondary:
            return dynamic(light: PlatformColor(red: 0.20, green: 0.78, blue: 0.35, alpha: 1.0),
                           dark: PlatformColor(red: 0.30, green: 0.85, blue: 0.45, alpha: 1.0))
        case .accent:
            return dynamic(light: PlatformColor(red: 1.00, green: 0.62, blue: 0.04, alpha: 1.0),
                           dark: PlatformColor(red: 1.00, green: 0.70, blue: 0.20, alpha: 1.0))
        case .backgroundPrimary:
            return dynamic(light: PlatformColor(red: 0.98, green: 0.98, blue: 0.99, alpha: 1.0),
                           dark: PlatformColor(red: 0.10, green: 0.11, blue: 0.12, alpha: 1.0))
        case .backgroundSecondary:
            return dynamic(light: PlatformColor(red: 0.95, green: 0.96, blue: 0.98, alpha: 1.0),
                           dark: PlatformColor(red: 0.15, green: 0.16, blue: 0.18, alpha: 1.0))
        case .backgroundTertiary:
            return dynamic(light: PlatformColor(red: 0.92, green: 0.93, blue: 0.95, alpha: 1.0),
                           dark: PlatformColor(red: 0.20, green: 0.21, blue: 0.24, alpha: 1.0))
        case .textPrimary:
            return dynamic(light: PlatformColor(red: 0.08, green: 0.09, blue: 0.11, alpha: 1.0),
                           dark: PlatformColor(red: 0.94, green: 0.95, blue: 0.97, alpha: 1.0))
        case .textSecondary:
            return dynamic(light: PlatformColor(red: 0.33, green: 0.34, blue: 0.37, alpha: 1.0),
                           dark: PlatformColor(red: 0.70, green: 0.72, blue: 0.76, alpha: 1.0))
        case .textTertiary:
            return dynamic(light: PlatformColor(red: 0.50, green: 0.51, blue: 0.55, alpha: 1.0),
                           dark: PlatformColor(red: 0.55, green: 0.57, blue: 0.60, alpha: 1.0))
        case .textDisabled:
            return dynamic(light: PlatformColor(red: 0.70, green: 0.71, blue: 0.73, alpha: 1.0),
                           dark: PlatformColor(red: 0.40, green: 0.41, blue: 0.43, alpha: 1.0))
        case .success:
            return dynamic(light: PlatformColor(red: 0.18, green: 0.78, blue: 0.35, alpha: 1.0),
                           dark: PlatformColor(red: 0.22, green: 0.85, blue: 0.42, alpha: 1.0))
        case .warning:
            return dynamic(light: PlatformColor(red: 1.00, green: 0.62, blue: 0.04, alpha: 1.0),
                           dark: PlatformColor(red: 1.00, green: 0.72, blue: 0.20, alpha: 1.0))
        case .error:
            return dynamic(light: PlatformColor(red: 0.93, green: 0.26, blue: 0.24, alpha: 1.0),
                           dark: PlatformColor(red: 1.00, green: 0.38, blue: 0.36, alpha: 1.0))
        case .info:
            return dynamic(light: PlatformColor(red: 0.17, green: 0.55, blue: 0.96, alpha: 1.0),
                           dark: PlatformColor(red: 0.35, green: 0.66, blue: 1.00, alpha: 1.0))
        case .border:
            return dynamic(light: PlatformColor(red: 0.84, green: 0.85, blue: 0.88, alpha: 1.0),
                           dark: PlatformColor(red: 0.25, green: 0.26, blue: 0.28, alpha: 1.0))
        case .separator:
            return dynamic(light: PlatformColor(red: 0.90, green: 0.91, blue: 0.94, alpha: 1.0),
                           dark: PlatformColor(red: 0.20, green: 0.21, blue: 0.24, alpha: 1.0))
        }
    }

    private static func dynamic(light: PlatformColor, dark: PlatformColor) -> Color {
        #if canImport(UIKit)
        return Color(UIColor { traits in
            traits.userInterfaceStyle == .dark ? dark : light
        })
        #elseif canImport(AppKit)
        let dynamic = NSColor(name: nil) { appearance in
            let match = appearance.bestMatch(from: [.darkAqua, .aqua])
            return match == .darkAqua ? dark : light
        }
        return Color(dynamic)
        #else
        return Color(light)
        #endif
    }
}

#if canImport(UIKit)
private typealias PlatformColor = UIColor
#elseif canImport(AppKit)
private typealias PlatformColor = NSColor
#else
private typealias PlatformColor = Color
#endif

public extension Color {
    /// Returns a color token from the app design system.
    static func app(_ token: AppColors.Token) -> Color {
        AppColors.color(token)
    }
}

#if DEBUG
struct AppColors_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(AppColors.Token.allCases, id: \.self) { token in
                HStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.app(token))
                        .frame(width: 24, height: 24)
                    Text(String(describing: token))
                        .font(.app(.caption, weight: .medium))
                        .foregroundColor(.app(.textPrimary))
                }
            }
        }
        .padding()
        .background(Color.app(.backgroundPrimary))
        .previewDisplayName("App Colors")
    }
}
#endif
