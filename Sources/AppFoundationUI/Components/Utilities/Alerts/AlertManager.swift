import SwiftUI

public enum AppAlertStyle: Sendable {
    case info
    case confirmation
    case destructive

    var icon: String {
        switch self {
        case .info: return "info.circle.fill"
        case .confirmation: return "checkmark.circle.fill"
        case .destructive: return "exclamationmark.triangle.fill"
        }
    }

    var tint: Color {
        switch self {
        case .info: return .app(.info)
        case .confirmation: return .app(.success)
        case .destructive: return .app(.error)
        }
    }
}

public struct AppAlertAction: Identifiable, Sendable {
    public enum Role: Sendable { case cancel, destructive, normal }
    public let id = UUID()
    public let title: String
    public let role: Role
    public let handler: @Sendable () -> Void

    public init(title: String, role: Role = .normal, handler: @escaping @Sendable () -> Void = {}) {
        self.title = title
        self.role = role
        self.handler = handler
    }
}

public struct AppAlert: Identifiable, Sendable {
    public let id = UUID()
    public let title: String
    public let message: String?
    public let style: AppAlertStyle
    public let actions: [AppAlertAction]

    public init(title: String,
                message: String? = nil,
                style: AppAlertStyle = .info,
                actions: [AppAlertAction] = [AppAlertAction(title: "OK")]) {
        self.title = title
        self.message = message
        self.style = style
        self.actions = actions
    }
}

@MainActor
public final class AlertManager: ObservableObject {
    @Published public var current: AppAlert?

    public init() {}

    public func present(_ alert: AppAlert) {
        current = alert
    }
}

public extension View {
    func appAlert(manager: AlertManager) -> some View {
        modifier(AppAlertModifier(manager: manager))
    }
}

private struct AppAlertModifier: ViewModifier {
    @ObservedObject var manager: AlertManager

    func body(content: Content) -> some View {
        content.alert(item: $manager.current) { alert in
            let buttons = alert.actions
            let primary = buttons.first
            let secondary = buttons.count > 1 ? buttons[1] : nil
            return Alert(
                title: Text(alert.title),
                message: alert.message.map(Text.init),
                primaryButton: primary.map { mapButton($0, style: alert.style) } ?? .default(Text("OK")),
                secondaryButton: secondary.map { mapButton($0, style: alert.style) } ?? .cancel()
            )
        }
    }

    private func mapButton(_ action: AppAlertAction, style: AppAlertStyle) -> Alert.Button {
        let title = Text(action.title)
        switch action.role {
        case .cancel: return .cancel(title, action: action.handler)
        case .destructive: return .destructive(title, action: action.handler)
        case .normal:
            return .default(title, action: action.handler)
        }
    }
}
