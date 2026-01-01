import SwiftUI

public struct ModalWrapper<Content: View>: View {
    private let title: String?
    private let showsClose: Bool
    private let allowDragToDismiss: Bool
    private let content: Content
    private let onClose: () -> Void

    public init(title: String? = nil,
                showsClose: Bool = true,
                allowDragToDismiss: Bool = true,
                onClose: @escaping () -> Void,
                @ViewBuilder content: () -> Content) {
        self.title = title
        self.showsClose = showsClose
        self.allowDragToDismiss = allowDragToDismiss
        self.content = content()
        self.onClose = onClose
    }

    public var body: some View {
        VStack(spacing: AppSpacing.medium.rawValue) {
            HStack {
                if let title {
                    Text(title)
                        .font(.app(.headline, weight: .semibold))
                        .foregroundColor(.app(.textPrimary))
                }
                Spacer()
                if showsClose {
                    Button(action: onClose) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.app(.textSecondary))
                            .font(.system(size: 20, weight: .semibold))
                    }
                    .accessibilityLabel("Close")
                }
            }
            .padding(.horizontal, AppSpacing.medium.rawValue)
            .padding(.top, AppSpacing.medium.rawValue)

            content
                .padding(.horizontal, AppSpacing.medium.rawValue)

            Spacer(minLength: allowDragToDismiss ? AppSpacing.small.rawValue : 0)
        }
        .padding(.bottom, AppSpacing.large.rawValue)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.app(.backgroundPrimary).ignoresSafeArea())
    }
}

#if DEBUG
struct ModalWrapper_Previews: PreviewProvider {
    static var previews: some View {
        ModalWrapper(title: "Modal", onClose: {}) {
            Text("Content")
        }
    }
}
#endif
