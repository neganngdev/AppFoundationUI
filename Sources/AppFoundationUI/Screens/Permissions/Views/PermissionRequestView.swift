import SwiftUI

public struct PermissionRequestView: View {
    private let request: PermissionRequest
    private let onAllow: () -> Void
    private let onDeny: () -> Void

    public init(request: PermissionRequest,
                onAllow: @escaping () -> Void,
                onDeny: @escaping () -> Void) {
        self.request = request
        self.onAllow = onAllow
        self.onDeny = onDeny
    }

    public var body: some View {
        VStack(spacing: AppSpacing.large.rawValue) {
            Spacer()
            Image(systemName: request.icon)
                .font(.system(size: 64, weight: .semibold))
                .foregroundColor(.app(.accent))
                .accessibilityHidden(true)

            VStack(spacing: AppSpacing.small.rawValue) {
                Text(request.title)
                    .font(.app(.title, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.app(.textPrimary))
                Text(request.description)
                    .font(.app(.body))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.app(.textSecondary))
                    .padding(.horizontal, AppSpacing.large.rawValue)
            }

            VStack(spacing: AppSpacing.small.rawValue) {
                AppButton("Allow", style: .primary) { onAllow() }
                AppButton("Not Now", style: .secondary) { onDeny() }
            }
            .padding(.horizontal, AppSpacing.large.rawValue)
            Spacer()
        }
        .background(Color.app(.backgroundPrimary).ignoresSafeArea())
    }
}

#if DEBUG
struct PermissionRequestView_Previews: PreviewProvider {
    static var previews: some View {
        PermissionRequestView(request: PermissionRequest(icon: "bell.badge",
                                                         title: "Stay in the loop",
                                                         description: "Enable notifications to get timely alerts",
                                                         type: .notifications),
                              onAllow: {},
                              onDeny: {})
    }
}
#endif
