import SwiftUI

public struct PaywallTemplateSingle: View {
    @StateObject private var coordinator: PaywallCoordinator
    private let heroTitle: String
    private let subtitle: String?
    private let socialProof: String?

    public init(plan: SubscriptionPlan,
                heroTitle: String = "Upgrade",
                subtitle: String? = nil,
                socialProof: String? = nil,
                onPurchaseSuccess: @escaping (SubscriptionPlan) -> Void,
                onDismiss: @escaping () -> Void) {
        self._coordinator = StateObject(wrappedValue: PaywallCoordinator(plans: [plan],
                                                                        defaultSelectedPlan: plan,
                                                                        onPurchaseSuccess: onPurchaseSuccess,
                                                                        onDismiss: onDismiss))
        self.heroTitle = heroTitle
        self.subtitle = subtitle
        self.socialProof = socialProof
    }

    public var body: some View {
        VStack(spacing: AppSpacing.large.rawValue) {
            VStack(spacing: AppSpacing.xSmall.rawValue) {
                Text(heroTitle)
                    .font(.app(.largeTitle, weight: .bold))
                    .foregroundColor(.app(.textPrimary))
                if let subtitle {
                    Text(subtitle)
                        .font(.app(.body))
                        .foregroundColor(.app(.textSecondary))
                        .multilineTextAlignment(.center)
                }
                if let socialProof {
                    Text(socialProof)
                        .font(.app(.caption, weight: .medium))
                        .foregroundColor(.app(.accent))
                }
            }
            .padding(.top, AppSpacing.large.rawValue)
            .padding(.horizontal, AppSpacing.large.rawValue)

            SubscriptionPlanCard(plan: coordinator.selectedPlan, isSelected: true) {}
                .padding(.horizontal, AppSpacing.medium.rawValue)

            VStack(alignment: .leading, spacing: AppSpacing.xxSmall.rawValue) {
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

            AppButton(coordinator.isLoading ? "Processing..." : "Get Started",
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
struct PaywallTemplateSingle_Previews: PreviewProvider {
    static var previews: some View {
        PaywallTemplateSingle(plan: .mockPopular,
                              heroTitle: "Unlock Pro",
                              subtitle: "Boost productivity with all features",
                              socialProof: "4.8 rating from 10k users",
                              onPurchaseSuccess: { _ in },
                              onDismiss: {})
    }
}
#endif
