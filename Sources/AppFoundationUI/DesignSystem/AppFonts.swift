import SwiftUI

/// Typography system for consistent text styling.
///
/// Usage:
/// ```swift
/// Text("Headline")
///     .font(.app(.headline, weight: .semibold))
/// ```
public struct AppFonts {
    public enum TextStyle: CaseIterable {
        case largeTitle
        case title
        case title2
        case title3
        case headline
        case subheadline
        case body
        case callout
        case caption
        case footnote
    }

    public enum Weight: CaseIterable {
        case regular
        case medium
        case semibold
        case bold

        var fontWeight: Font.Weight {
            switch self {
            case .regular: return .regular
            case .medium: return .medium
            case .semibold: return .semibold
            case .bold: return .bold
            }
        }
    }

    /// Returns a design system font. Use a custom font name or provide one via `ThemeProvider`.
    public static func font(_ style: TextStyle,
                            weight: Weight = .regular,
                            customFontName: String? = nil) -> Font {
        let size = size(for: style)
        if let customFontName {
            return .custom(customFontName, size: size).weight(weight.fontWeight)
        }
        return .system(size: size, weight: weight.fontWeight)
    }

    private static func size(for style: TextStyle) -> CGFloat {
        switch style {
        case .largeTitle: return 34
        case .title: return 28
        case .title2: return 22
        case .title3: return 20
        case .headline: return 17
        case .subheadline: return 15
        case .body: return 17
        case .callout: return 16
        case .caption: return 12
        case .footnote: return 13
        }
    }
}

public extension Font {
    /// Returns a design-system font.
    static func app(_ style: AppFonts.TextStyle,
                    weight: AppFonts.Weight = .regular,
                    customFontName: String? = nil) -> Font {
        AppFonts.font(style, weight: weight, customFontName: customFontName)
    }
}

#if DEBUG
struct AppFonts_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Large Title").font(.app(.largeTitle, weight: .bold))
            Text("Title").font(.app(.title, weight: .semibold))
            Text("Title2").font(.app(.title2))
            Text("Title3").font(.app(.title3))
            Text("Headline").font(.app(.headline, weight: .medium))
            Text("Subheadline").font(.app(.subheadline))
            Text("Body").font(.app(.body))
            Text("Callout").font(.app(.callout))
            Text("Caption").font(.app(.caption))
            Text("Footnote").font(.app(.footnote))
        }
        .padding()
        .previewDisplayName("App Fonts")
    }
}
#endif
