import SwiftUI

public struct PlanSelector: View {
    public let plans: [SubscriptionPlan]
    @Binding public var selectedPlan: SubscriptionPlan

    public init(plans: [SubscriptionPlan], selectedPlan: Binding<SubscriptionPlan>) {
        self.plans = plans
        self._selectedPlan = selectedPlan
    }

    public var body: some View {
        HStack(spacing: AppSpacing.xSmall.rawValue) {
            ForEach(plans) { plan in
                Button {
                    selectedPlan = plan
                } label: {
                    VStack(spacing: AppSpacing.xxSmall.rawValue) {
                        Text(plan.name)
                            .font(.app(.subheadline, weight: .semibold))
                        Text(plan.price)
                            .font(.app(.caption))
                            .foregroundColor(.app(.textSecondary))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppSpacing.xSmall.rawValue)
                    .background(selectedPlan.id == plan.id ? Color.app(.primary) : Color.app(.backgroundSecondary))
                    .foregroundColor(selectedPlan.id == plan.id ? Color.app(.backgroundPrimary) : Color.app(.textPrimary))
                    .appCornerRadius(AppRadius.medium)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Select plan \(plan.name)")
                .accessibilityHint(selectedPlan.id == plan.id ? "Selected" : "")
            }
        }
    }
}

#if DEBUG
struct PlanSelector_Previews: PreviewProvider {
    static var previews: some View {
        PreviewState(initialValue: SubscriptionPlan.mockPopular) { binding in
            PlanSelector(plans: [.mockPopular, .mockBasic], selectedPlan: binding)
                .appPadding(AppSpacing.medium)
                .previewDisplayName("PlanSelector")
        }
    }
}

private struct PreviewState<Value, Content: View>: View {
    @State private var value: Value
    private let content: (Binding<Value>) -> Content

    init(initialValue: Value, @ViewBuilder content: @escaping (Binding<Value>) -> Content) {
        self._value = State(initialValue: initialValue)
        self.content = content
    }

    var body: some View {
        content($value)
    }
}
#endif
