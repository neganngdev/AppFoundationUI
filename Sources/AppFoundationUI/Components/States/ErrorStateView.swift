import SwiftUI

public enum ErrorStateStyle: CaseIterable {
    case inline
    case fullScreen
}

public struct ErrorStateView: View {
    private let icon: String
    private let title: String
    private let message: String
    private let retryTitle: String
    private let style: ErrorStateStyle
    private let retryAction: (() -> Void)?

    public init(icon: String = "exclamationmark.triangle",
                title: String = "Something went wrong",
                message: String,
                retryTitle: String = "Retry",
                style: ErrorStateStyle = .inline,
                retryAction: (() -> Void)? = nil) {
        self.icon = icon
        self.title = title
        self.message = message
        self.retryTitle = retryTitle
        self.style = style
        self.retryAction = retryAction
    }

    public init(error: Error,
                icon: String = "exclamationmark.triangle",
                title: String = "Something went wrong",
                retryTitle: String = "Retry",
                style: ErrorStateStyle = .inline,
                retryAction: (() -> Void)? = nil) {
        self.init(icon: icon,
                  title: title,
                  message: error.localizedDescription,
                  retryTitle: retryTitle,
                  style: style,
                  retryAction: retryAction)
    }

    public var body: some View {
        VStack(spacing: AppSpacing.medium.rawValue) {
            Image(systemName: icon)
                .font(.system(size: style == .fullScreen ? 48 : 32, weight: .semibold))
                .foregroundColor(.app(.error))
                .accessibilityHidden(true)

            VStack(spacing: AppSpacing.xSmall.rawValue) {
                Text(title)
                    .font(.app(.title3, weight: .semibold))
                    .foregroundColor(.app(.textPrimary))
                Text(message)
                    .font(.app(.body))
                    .foregroundColor(.app(.textSecondary))
                    .multilineTextAlignment(.center)
            }

            if let retryAction {
                AppButton(retryTitle, style: .secondary, action: retryAction)
            }
        }
        .frame(maxWidth: style == .fullScreen ? 420 : .infinity)
        .padding(style == .fullScreen ? AppSpacing.large.rawValue : AppSpacing.medium.rawValue)
        .accessibilityElement(children: .combine)
    }
}

#if DEBUG
struct ErrorStateView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: AppSpacing.large.rawValue) {
            ErrorStateView(message: "We could not load the dashboard.")
            ErrorStateView(message: "We could not refresh your data.", style: .fullScreen) {}
        }
        .appPadding(AppSpacing.medium)
        .previewDisplayName("ErrorStateView")
    }
}
#endif
