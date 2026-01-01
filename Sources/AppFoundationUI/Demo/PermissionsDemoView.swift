import SwiftUI

struct PermissionsDemoView: View {
    @State private var showTracking = false

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.large.rawValue) {
                NotificationPermissionView(onAllow: {}, onDeny: {})
                TrackingPermissionView(onAllow: {}, onDeny: {})
            }
            .appPadding(AppSpacing.medium)
        }
        .background(Color.app(.backgroundPrimary))
    }
}

#if DEBUG
struct PermissionsDemoView_Previews: PreviewProvider {
    static var previews: some View {
        PermissionsDemoView()
    }
}
#endif
