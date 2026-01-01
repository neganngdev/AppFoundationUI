import SwiftUI

public struct AppLoadingView: View {
    private let message: String?

    public init(message: String? = nil) {
        self.message = message
    }

    public var body: some View {
        VStack(spacing: AppSpacing.small.rawValue) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .app(.accent)))
                .scaleEffect(1.1)

            if let message {
                Text(message)
                    .font(.app(.callout))
                    .foregroundColor(.app(.textSecondary))
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(message ?? "Loading")
    }
}

#if DEBUG
struct AppLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 24) {
            AppLoadingView()
            AppLoadingView(message: "Loading content")
        }
        .appPadding(AppSpacing.medium)
        .previewDisplayName("AppLoadingView")
    }
}
#endif
