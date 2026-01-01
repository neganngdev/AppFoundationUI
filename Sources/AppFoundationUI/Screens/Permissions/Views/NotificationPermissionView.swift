import SwiftUI
#if canImport(UserNotifications)
import UserNotifications
#endif

public struct NotificationPermissionView: View {
    private let title: String
    private let description: String
    private let onAllow: () -> Void
    private let onDeny: () -> Void

    public init(title: String = "Stay in the loop",
                description: String = "Enable notifications to get reminders and important updates.",
                onAllow: @escaping () -> Void,
                onDeny: @escaping () -> Void) {
        self.title = title
        self.description = description
        self.onAllow = onAllow
        self.onDeny = onDeny
    }

    public var body: some View {
        PermissionRequestView(request: PermissionRequest(icon: "bell.badge",
                                                        title: title,
                                                        description: description,
                                                        type: .notifications),
                              onAllow: {
            requestSystemPermission()
            onAllow()
        }, onDeny: onDeny)
    }

    private func requestSystemPermission() {
        #if canImport(UserNotifications)
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
        #endif
    }
}

#if DEBUG
struct NotificationPermissionView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationPermissionView(onAllow: {}, onDeny: {})
    }
}
#endif
