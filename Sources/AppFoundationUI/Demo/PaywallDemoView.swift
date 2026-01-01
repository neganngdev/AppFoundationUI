import SwiftUI

struct PaywallDemoView: View {
    private let plans: [SubscriptionPlan] = [
        .mockPopular,
        .mockBasic
    ]

    var body: some View {
        PaywallTemplateVertical(plans: plans, onPurchaseSuccess: { _ in }, onDismiss: {})
            .background(Color.app(.backgroundPrimary))
    }
}

#if DEBUG
struct PaywallDemoView_Previews: PreviewProvider {
    static var previews: some View {
        PaywallDemoView()
    }
}
#endif
