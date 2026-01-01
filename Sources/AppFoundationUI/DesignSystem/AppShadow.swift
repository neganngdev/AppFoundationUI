import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

/// Shadow presets for elevation.
public struct AppShadow {
    public struct Elevation: Sendable {
        public let color: Color
        public let radius: CGFloat
        public let x: CGFloat
        public let y: CGFloat

        public init(color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) {
            self.color = color
            self.radius = radius
            self.x = x
            self.y = y
        }
    }

    public enum Style: CaseIterable {
        case small
        case medium
        case large
    }

    public static func elevation(_ style: Style) -> Elevation {
        let color = dynamicShadowColor()
        switch style {
        case .small:
            return Elevation(color: color, radius: 4, x: 0, y: 2)
        case .medium:
            return Elevation(color: color, radius: 8, x: 0, y: 4)
        case .large:
            return Elevation(color: color, radius: 16, x: 0, y: 8)
        }
    }

    private static func dynamicShadowColor() -> Color {
        #if canImport(UIKit)
        return Color(UIColor { traits in
            if traits.userInterfaceStyle == .dark {
                return UIColor.black.withAlphaComponent(0.6)
            }
            return UIColor.black.withAlphaComponent(0.12)
        })
        #elseif canImport(AppKit)
        let dynamic = NSColor(name: nil) { appearance in
            let match = appearance.bestMatch(from: [.darkAqua, .aqua])
            if match == .darkAqua {
                return NSColor.black.withAlphaComponent(0.6)
            }
            return NSColor.black.withAlphaComponent(0.12)
        }
        return Color(dynamic)
        #else
        return Color.black.opacity(0.12)
        #endif
    }
}

#if DEBUG
struct AppShadow_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 24) {
            ForEach(AppShadow.Style.allCases, id: \.self) { style in
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.app(.backgroundPrimary))
                    .frame(width: 72, height: 72)
                    .shadow(color: AppShadow.elevation(style).color,
                            radius: AppShadow.elevation(style).radius,
                            x: AppShadow.elevation(style).x,
                            y: AppShadow.elevation(style).y)
                    .overlay(Text(String(describing: style)).font(.app(.caption)))
            }
        }
        .padding()
        .background(Color.app(.backgroundSecondary))
        .previewDisplayName("App Shadow")
    }
}
#endif
