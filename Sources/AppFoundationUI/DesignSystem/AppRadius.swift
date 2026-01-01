import SwiftUI

/// Corner radius tokens for consistent rounding.
public struct AppRadius {
    public struct Value: Hashable, Sendable {
        public let rawValue: CGFloat

        public init(_ rawValue: CGFloat) {
            self.rawValue = rawValue
        }
    }

    public static let small = Value(4)
    public static let medium = Value(8)
    public static let large = Value(12)
    public static let xLarge = Value(16)
}

public extension CGFloat {
    /// Returns a radius value from the design system.
    static func app(_ value: AppRadius.Value) -> CGFloat {
        value.rawValue
    }
}

#if DEBUG
struct AppRadius_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 12) {
            ForEach([AppRadius.small, AppRadius.medium, AppRadius.large, AppRadius.xLarge], id: \.rawValue) { radius in
                RoundedRectangle(cornerRadius: radius.rawValue)
                    .fill(Color.app(.primary))
                    .frame(width: 48, height: 48)
            }
        }
        .padding()
        .previewDisplayName("App Radius")
    }
}
#endif
