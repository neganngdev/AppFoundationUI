import SwiftUI

/// Spacing scale for padding and layout.
///
/// Usage:
/// ```swift
/// VStack(spacing: .app(.medium)) { ... }
/// ```
public struct AppSpacing {
    public struct Value: Hashable, Sendable {
        public let rawValue: CGFloat

        public init(_ rawValue: CGFloat) {
            self.rawValue = rawValue
        }
    }

    public static let xxxSmall = Value(2)
    public static let xxSmall = Value(4)
    public static let xSmall = Value(8)
    public static let small = Value(12)
    public static let medium = Value(16)
    public static let large = Value(24)
    public static let xLarge = Value(32)
    public static let xxLarge = Value(48)
}

public extension CGFloat {
    /// Returns a spacing value from the design system.
    static func app(_ value: AppSpacing.Value) -> CGFloat {
        value.rawValue
    }
}

#if DEBUG
struct AppSpacing_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Spacing Scale").font(.app(.headline, weight: .semibold))
            ForEach([AppSpacing.xxxSmall, AppSpacing.xxSmall, AppSpacing.xSmall, AppSpacing.small,
                     AppSpacing.medium, AppSpacing.large, AppSpacing.xLarge, AppSpacing.xxLarge],
                    id: \.rawValue) { value in
                HStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.app(.accent))
                        .frame(width: value.rawValue, height: 8)
                    Text("\(Int(value.rawValue))")
                        .font(.app(.caption))
                        .foregroundColor(.app(.textSecondary))
                }
            }
        }
        .padding()
        .previewDisplayName("App Spacing")
    }
}
#endif
