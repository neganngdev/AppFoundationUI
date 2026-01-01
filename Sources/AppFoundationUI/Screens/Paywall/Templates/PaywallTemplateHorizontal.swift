import SwiftUI

public struct PaywallTemplateHorizontal: View {
    @StateObject private var coordinator: PaywallCoordinator
    private let plans: [SubscriptionPlan]

    public init(plans: [SubscriptionPlan],
                defaultSelectedPlan: SubscriptionPlan? = nil,
                onPurchaseSuccess: @escaping (SubscriptionPlan) -> Void,
                onDismiss: @escaping () -> Void) {
        self._coordinator = StateObject(wrappedValue: PaywallCoordinator(plans: plans,
                                                                        defaultSelectedPlan: defaultSelectedPlan,
                                                                        onPurchaseSuccess: onPurchaseSuccess,
                                                                        onDismiss: onDismiss))
        self.plans = plans
    }

    public var body: some View {
        VStack(spacing: AppSpacing.large.rawValue) {
            PlanSelector(plans: plans, selectedPlan: $coordinator.selectedPlan)
                .padding(.top, AppSpacing.large.rawValue)
                .padding(.horizontal, AppSpacing.medium.rawValue)

            VStack(alignment: .leading, spacing: AppSpacing.small.rawValue) {
                Text("What's included")
                    .font(.app(.headline, weight: .semibold))
                    .foregroundColor(.app(.textPrimary))
                ForEach(coordinator.selectedPlan.features) { feature in
                    FeatureRow(text: feature.text)
                }
            }
            .padding(.horizontal, AppSpacing.medium.rawValue)

            if let error = coordinator.errorMessage {
                Text(error)
                    .font(.app(.caption))
                    .foregroundColor(.app(.error))
                    .padding(.horizontal, AppSpacing.medium.rawValue)
            }

            AppButton(coordinator.isLoading ? "Processing..." : "Continue",
                      style: .primary,
                      isLoading: coordinator.isLoading) {
                Task { await coordinator.purchase() }
            }
            .disabled(coordinator.isLoading)
            .padding(.horizontal, AppSpacing.medium.rawValue)

            Button("Restore Purchases") {
                Task { await coordinator.restore() }
            }
            .font(.app(.caption, weight: .semibold))
            .foregroundColor(.app(.textSecondary))

            Spacer(minLength: AppSpacing.large.rawValue)
        }
        .background(Color.app(.backgroundPrimary).ignoresSafeArea())
    }
}

#if DEBUG
struct PaywallTemplateHorizontal_Previews: PreviewProvider {
    static let plans = [SubscriptionPlan.mockPopular, .mockBasic]
    static var previews: some View {
        PaywallTemplateHorizontal(plans: plans, onPurchaseSuccess: { _ in }, onDismiss: {})
    }
}
#endif
