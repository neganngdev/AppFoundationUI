import SwiftUI

public enum ToastType: Sendable {
    case success
    case error
    case warning
    case info

    var icon: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.octagon.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .info: return "info.circle.fill"
        }
    }

    var background: Color {
        switch self {
        case .success: return .app(.success)
        case .error: return .app(.error)
        case .warning: return .app(.warning)
        case .info: return .app(.info)
        }
    }
}

public struct Toast: Identifiable, Equatable, Sendable {
    public let id = UUID()
    public let message: String
    public let type: ToastType
    public let duration: TimeInterval

    public init(message: String, type: ToastType = .info, duration: TimeInterval = 2.5) {
        self.message = message
        self.type = type
        self.duration = duration
    }
}

public struct ToastView: View {
    let toast: Toast

    public init(toast: Toast) {
        self.toast = toast
    }

    public var body: some View {
        HStack(alignment: .center, spacing: AppSpacing.xSmall.rawValue) {
            Image(systemName: toast.type.icon)
                .foregroundColor(.app(.backgroundPrimary))
                .font(.system(size: 18, weight: .semibold))
            Text(toast.message)
                .font(.app(.body, weight: .semibold))
                .foregroundColor(.app(.backgroundPrimary))
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            Spacer(minLength: 0)
        }
        .padding(.vertical, AppSpacing.small.rawValue)
        .padding(.horizontal, AppSpacing.medium.rawValue)
        .background(toast.type.background)
        .appCornerRadius(AppRadius.large)
        .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(toast.message)
    }
}

#if DEBUG
struct ToastView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: AppSpacing.small.rawValue) {
            ToastView(toast: Toast(message: "Saved!", type: .success))
            ToastView(toast: Toast(message: "Error occurred", type: .error))
        }
        .appPadding(AppSpacing.medium)
        .background(Color.app(.backgroundPrimary))
        .previewDisplayName("ToastView")
    }
}
#endif
