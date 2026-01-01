import SwiftUI

public struct EmptyStateView: View {
    public struct Action {
        public let title: String
        public let action: () -> Void

        public init(title: String, action: @escaping () -> Void) {
            self.title = title
            self.action = action
        }
    }

    public struct Configuration {
        public let icon: String
        public let title: String
        public let message: String
        public let action: Action?

        public init(icon: String, title: String, message: String, action: Action? = nil) {
            self.icon = icon
            self.title = title
            self.message = message
            self.action = action
        }
    }

    private let configuration: Configuration

    public init(icon: String, title: String, message: String, action: Action? = nil) {
        self.configuration = Configuration(icon: icon, title: title, message: message, action: action)
    }

    public init(configuration: Configuration) {
        self.configuration = configuration
    }

    public var body: some View {
        VStack(spacing: AppSpacing.medium.rawValue) {
            Image(systemName: configuration.icon)
                .font(.system(size: 40, weight: .semibold))
                .foregroundColor(.app(.textTertiary))
                .accessibilityHidden(true)

            VStack(spacing: AppSpacing.xSmall.rawValue) {
                Text(configuration.title)
                    .font(.app(.title3, weight: .semibold))
                    .foregroundColor(.app(.textPrimary))
                Text(configuration.message)
                    .font(.app(.body))
                    .foregroundColor(.app(.textSecondary))
                    .multilineTextAlignment(.center)
            }

            if let action = configuration.action {
                AppButton(action.title, style: .primary, action: action.action)
            }
        }
        .frame(maxWidth: 360)
        .padding(AppSpacing.medium.rawValue)
        .accessibilityElement(children: .combine)
    }
}

public enum EmptyStatePreset {
    case noData
    case noResults
    case noConnection

    public var configuration: EmptyStateView.Configuration {
        switch self {
        case .noData:
            return EmptyStateView.Configuration(
                icon: "tray",
                title: "No Data",
                message: "There is nothing here yet. Add your first item to get started."
            )
        case .noResults:
            return EmptyStateView.Configuration(
                icon: "magnifyingglass",
                title: "No Results",
                message: "Try adjusting your filters or searching for something else."
            )
        case .noConnection:
            return EmptyStateView.Configuration(
                icon: "wifi.slash",
                title: "No Connection",
                message: "Check your internet connection and try again."
            )
        }
    }
}

#if DEBUG
struct EmptyStateView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: AppSpacing.large.rawValue) {
            EmptyStateView(configuration: EmptyStatePreset.noData.configuration)
            EmptyStateView(
                icon: "tray",
                title: "No Items",
                message: "Add your first item",
                action: .init(title: "Add Item") {}
            )
        }
        .appPadding(AppSpacing.medium)
        .previewDisplayName("EmptyStateView")
    }
}
#endif
