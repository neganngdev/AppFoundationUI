import SwiftUI

public struct AppToggle: View {
    @Binding private var isOn: Bool
    private let title: String
    private let description: String?
    private let isEnabled: Bool

    public init(isOn: Binding<Bool>,
                title: String,
                description: String? = nil,
                isEnabled: Bool = true) {
        self._isOn = isOn
        self.title = title
        self.description = description
        self.isEnabled = isEnabled
    }

    public var body: some View {
        Toggle(isOn: $isOn) {
            VStack(alignment: .leading, spacing: AppSpacing.xxSmall.rawValue) {
                Text(title)
                    .font(.app(.body, weight: .semibold))
                    .foregroundColor(.app(.textPrimary))
                if let description {
                    Text(description)
                        .font(.app(.caption))
                        .foregroundColor(.app(.textSecondary))
                }
            }
        }
        .toggleStyle(SwitchToggleStyle(tint: .app(.primary)))
        .disabled(!isEnabled)
    }
}

#if DEBUG
struct AppToggle_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: AppSpacing.medium.rawValue) {
            AppToggle(isOn: .constant(true), title: "Push Notifications", description: "Receive updates")
            AppToggle(isOn: .constant(false), title: "Marketing Emails")
        }
        .appPadding(AppSpacing.medium)
        .previewDisplayName("AppToggle")
    }
}
#endif
