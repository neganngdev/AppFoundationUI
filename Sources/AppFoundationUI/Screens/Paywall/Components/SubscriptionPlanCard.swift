import SwiftUI

public struct SubscriptionPlan: Identifiable, Hashable, Sendable {
    public let id: String
    public let name: String
    public let price: String
    public let period: String
    public let badge: String?
    public let trialDescription: String?
    public let features: [PlanFeature]

    public init(id: String,
                name: String,
                price: String,
                period: String,
                badge: String? = nil,
                trialDescription: String? = nil,
                features: [PlanFeature] = []) {
        self.id = id
        self.name = name
        self.price = price
        self.period = period
        self.badge = badge
        self.trialDescription = trialDescription
        self.features = features
    }
}

public struct PlanFeature: Identifiable, Hashable, Sendable {
    public let id = UUID()
    public let text: String

    public init(_ text: String) {
        self.text = text
    }
}

public struct SubscriptionPlanCard: View {
    public let plan: SubscriptionPlan
    public let isSelected: Bool
    public let onTap: () -> Void

    public init(plan: SubscriptionPlan, isSelected: Bool, onTap: @escaping () -> Void) {
        self.plan = plan
        self.isSelected = isSelected
        self.onTap = onTap
    }

    public var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: AppSpacing.small.rawValue) {
                header
                priceRow
                featureList
                if let trial = plan.trialDescription {
                    Text(trial)
                        .font(.app(.caption, weight: .medium))
                        .foregroundColor(.app(.accent))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .appPadding(AppSpacing.medium)
            .background(background)
            .overlay(badgeOverlay, alignment: .topTrailing)
            .overlay(selectionOutline)
            .appCornerRadius(AppRadius.large)
            .appShadow(isSelected ? .medium : .small)
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityHint(isSelected ? "Selected" : "Not selected")
    }

    private var background: some View {
        RoundedRectangle(cornerRadius: AppRadius.large.rawValue)
            .fill(Color.app(.backgroundSecondary))
    }

    private var selectionOutline: some View {
        RoundedRectangle(cornerRadius: AppRadius.large.rawValue)
            .stroke(isSelected ? Color.app(.primary) : Color.app(.border), lineWidth: isSelected ? 2 : 1)
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: AppSpacing.xxSmall.rawValue) {
                Text(plan.name)
                    .font(.app(.headline, weight: .semibold))
                    .foregroundColor(.app(.textPrimary))
                Text(plan.period)
                    .font(.app(.caption))
                    .foregroundColor(.app(.textSecondary))
            }
            Spacer()
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.app(.primary))
            }
        }
    }

    private var priceRow: some View {
        HStack(alignment: .firstTextBaseline, spacing: AppSpacing.xxSmall.rawValue) {
            Text(plan.price)
                .font(.app(.title, weight: .bold))
                .foregroundColor(.app(.textPrimary))
            Text(plan.period)
                .font(.app(.subheadline))
                .foregroundColor(.app(.textSecondary))
        }
    }

    private var featureList: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xxSmall.rawValue) {
            ForEach(plan.features) { feature in
                FeatureRow(text: feature.text)
            }
        }
    }

    private var badgeOverlay: some View {
        Group {
            if let badge = plan.badge {
                Text(badge.uppercased())
                    .font(.app(.caption, weight: .semibold))
                    .foregroundColor(.app(.backgroundPrimary))
                    .padding(.horizontal, AppSpacing.xSmall.rawValue)
                    .padding(.vertical, AppSpacing.xxSmall.rawValue)
                    .background(Color.app(.accent))
                    .appCornerRadius(AppRadius.small)
                    .padding(AppSpacing.small.rawValue)
            }
        }
    }
}

#if DEBUG
struct SubscriptionPlanCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: AppSpacing.medium.rawValue) {
            SubscriptionPlanCard(plan: .mockPopular, isSelected: true) {}
            SubscriptionPlanCard(plan: .mockBasic, isSelected: false) {}
        }
        .appPadding(AppSpacing.medium)
        .previewDisplayName("SubscriptionPlanCard")
    }
}

#if DEBUG
public extension SubscriptionPlan {
    static let mockPopular = SubscriptionPlan(
        id: "pro_monthly",
        name: "Pro Monthly",
        price: "$4.99",
        period: "/month",
        badge: "Most Popular",
        trialDescription: "7-day free trial",
        features: [.init("Unlimited projects"), .init("Priority support"), .init("Sync across devices")]
    )

    static let mockBasic = SubscriptionPlan(
        id: "basic_yearly",
        name: "Basic Yearly",
        price: "$29.99",
        period: "/year",
        badge: nil,
        trialDescription: nil,
        features: [.init("All core features"), .init("Email support")]
    )
}
#endif
#endif
