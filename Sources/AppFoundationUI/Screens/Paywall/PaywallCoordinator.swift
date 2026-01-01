import SwiftUI
import AppFoundation

@MainActor
public final class PaywallCoordinator: ObservableObject {
    @Published public var selectedPlan: SubscriptionPlan
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?

    private let purchaseManager: PurchaseManager
    private let plans: [SubscriptionPlan]
    private let onDismiss: () -> Void
    private let onPurchaseSuccess: (SubscriptionPlan) -> Void

    public init(plans: [SubscriptionPlan],
                defaultSelectedPlan: SubscriptionPlan? = nil,
                purchaseManager: PurchaseManager = .shared,
                onPurchaseSuccess: @escaping (SubscriptionPlan) -> Void,
                onDismiss: @escaping () -> Void) {
        self.plans = plans
        self.selectedPlan = defaultSelectedPlan ?? plans.first ?? SubscriptionPlan(id: "", name: "", price: "", period: "")
        self.purchaseManager = purchaseManager
        self.onPurchaseSuccess = onPurchaseSuccess
        self.onDismiss = onDismiss
    }

    public func select(_ plan: SubscriptionPlan) {
        selectedPlan = plan
    }

    public func purchase() async {
        guard !selectedPlan.id.isEmpty else { return }
        isLoading = true
        errorMessage = nil
        do {
            let success = try await purchaseManager.purchase(productId: selectedPlan.id)
            if success {
                onPurchaseSuccess(selectedPlan)
                dismiss()
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    public func restore() async {
        isLoading = true
        errorMessage = nil
        do {
            _ = try await purchaseManager.restorePurchases()
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    public func dismiss() {
        onDismiss()
    }
}
