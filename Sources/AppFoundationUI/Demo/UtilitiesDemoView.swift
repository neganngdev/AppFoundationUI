import SwiftUI

struct UtilitiesDemoView: View {
    @StateObject private var toastManager = ToastManager()
    @State private var showSheet = false
    @State private var showModal = false

    var body: some View {
        VStack(spacing: AppSpacing.medium.rawValue) {
            Button("Show Toast") {
                toastManager.show(Toast(message: "Saved successfully", type: .success))
            }
            .buttonStyle(.appPrimary())

            Button("Show Sheet") { showSheet = true }
                .buttonStyle(.appSecondary())
                .bottomSheet(isPresented: $showSheet) {
                    ModalWrapper(title: "Sheet", onClose: { showSheet = false }) {
                        Text("Sheet content")
                            .appPadding(AppSpacing.medium)
                    }
                }

            Button("Show Modal Wrapper") { showModal = true }
                .buttonStyle(.appPrimary())
                .sheet(isPresented: $showModal) {
                    ModalWrapper(title: "Modal", onClose: { showModal = false }) {
                        Text("Modal content")
                            .appPadding(AppSpacing.medium)
                    }
                }

            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.small.rawValue) {
                    Text("Pull to refresh below").font(.app(.headline))
                    ForEach(0..<10) { index in
                        Text("Item \(index)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .appPadding(AppSpacing.small)
                            .background(Color.app(.backgroundSecondary))
                            .appCornerRadius(AppRadius.medium)
                    }
                }
                .appPadding(AppSpacing.medium)
            }
            .frame(height: 220)
            .pullToRefresh {
                try? await Task.sleep(nanoseconds: 500_000_000)
            }

            Spacer()
        }
        .toast(manager: toastManager)
        .appPadding(AppSpacing.medium)
        .background(Color.app(.backgroundPrimary))
    }
}

#if DEBUG
struct UtilitiesDemoView_Previews: PreviewProvider {
    static var previews: some View {
        UtilitiesDemoView()
    }
}
#endif
