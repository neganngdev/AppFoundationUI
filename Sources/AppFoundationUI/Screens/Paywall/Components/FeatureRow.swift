import SwiftUI

public struct FeatureRow: View {
    let text: String

    public init(text: String) {
        self.text = text
    }

    public var body: some View {
        HStack(alignment: .center, spacing: AppSpacing.xxSmall.rawValue) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.app(.primary))
                .font(.system(size: 16, weight: .semibold))
                .accessibilityHidden(true)
            Text(text)
                .font(.app(.body))
                .foregroundColor(.app(.textPrimary))
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#if DEBUG
struct FeatureRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xxSmall.rawValue) {
            FeatureRow(text: "Unlimited projects")
            FeatureRow(text: "Priority support")
        }
        .appPadding(AppSpacing.medium)
        .previewDisplayName("FeatureRow")
    }
}
#endif
