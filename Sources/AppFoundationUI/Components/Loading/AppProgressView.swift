import SwiftUI

public struct AppProgressView: View {
    private let title: String
    private let value: Double

    public init(title: String = "Progress", value: Double) {
        self.title = title
        self.value = value
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xSmall.rawValue) {
            HStack {
                Text(title)
                    .font(.app(.callout, weight: .semibold))
                    .foregroundColor(.app(.textPrimary))
                Spacer()
                Text("\(Int(value * 100))%")
                    .font(.app(.caption, weight: .medium))
                    .foregroundColor(.app(.textSecondary))
            }

            ProgressView(value: value)
                .tint(.app(.accent))
                .accessibilityValue("\(Int(value * 100)) percent")
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(title)
    }
}

#if DEBUG
struct AppProgressView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: AppSpacing.medium.rawValue) {
            AppProgressView(value: 0.25)
            AppProgressView(title: "Download", value: 0.72)
        }
        .appPadding(AppSpacing.medium)
        .previewDisplayName("AppProgressView")
    }
}
#endif
