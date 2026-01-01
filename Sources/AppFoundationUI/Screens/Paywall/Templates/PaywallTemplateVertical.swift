import SwiftUI

public struct PaywallTemplateVertical: View {
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
        VStack(spacing: AppSpacing.medium.rawValue) {
            ScrollView {
                VStack(spacing: AppSpacing.small.rawValue) {
                    ForEach(plans) { plan in
                        SubscriptionPlanCard(plan: plan,
                                             isSelected: coordinator.selectedPlan.id == plan.id) {
                            coordinator.select(plan)
                        }
                    }
                }
                .padding(.horizontal, AppSpacing.medium.rawValue)
                .padding(.top, AppSpacing.medium.rawValue)
            }

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

            termsLinks
        }
        .padding(.bottom, AppSpacing.large.rawValue)
        .background(Color.app(.backgroundPrimary).ignoresSafeArea())
    }

    private var termsLinks: some View {
        HStack(spacing: AppSpacing.xSmall.rawValue) {
            Button("Terms of Service", action: {})
                .font(.app(.caption))
            Text("|")
                .foregroundColor(.app(.textTertiary))
            Button("Privacy Policy", action: {})
                .font(.app(.caption))
        }
        .foregroundColor(.app(.textSecondary))
    }
}

#if DEBUG
struct PaywallTemplateVertical_Previews: PreviewProvider {
    static let plans = [SubscriptionPlan.mockPopular, .mockBasic]
    static var previews: some View {
        PaywallTemplateVertical(plans: plans, onPurchaseSuccess: { _ in }, onDismiss: {})
    }
}
#endif
