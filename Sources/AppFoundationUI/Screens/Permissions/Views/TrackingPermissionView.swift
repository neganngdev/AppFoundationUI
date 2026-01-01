import SwiftUI
#if os(iOS)
import AppTrackingTransparency
#endif

public struct TrackingPermissionView: View {
    private let title: String
    private let description: String
    private let onAllow: () -> Void
    private let onDeny: () -> Void

    public init(title: String = "Support a better experience",
                description: String = "We use tracking to keep the app sustainable and improve recommendations.",
                onAllow: @escaping () -> Void,
                onDeny: @escaping () -> Void) {
        self.title = title
        self.description = description
        self.onAllow = onAllow
        self.onDeny = onDeny
    }

    public var body: some View {
        PermissionRequestView(request: PermissionRequest(icon: "hand.point.up.left",
                                                        title: title,
                                                        description: description,
                                                        type: .tracking),
                              onAllow: {
            requestSystemPermission()
            onAllow()
        }, onDeny: onDeny)
    }

    private func requestSystemPermission() {
        #if os(iOS)
        if #available(iOS 14.5, *) {
            ATTrackingManager.requestTrackingAuthorization { _ in }
        }
        #endif
    }
}

#if DEBUG
struct TrackingPermissionView_Previews: PreviewProvider {
    static var previews: some View {
        TrackingPermissionView(onAllow: {}, onDeny: {})
    }
}
#endif
