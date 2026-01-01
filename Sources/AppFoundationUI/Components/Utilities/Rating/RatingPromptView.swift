import SwiftUI

public struct RatingPromptView: View {
    @State private var rating: Int = 0
    private let title: String
    private let message: String
    private let onSubmit: (Int) -> Void
    private let onLater: () -> Void

    public init(title: String = "Enjoying the app?",
                message: String = "Tap a star to rate. Your feedback helps us improve.",
                onSubmit: @escaping (Int) -> Void,
                onLater: @escaping () -> Void) {
        self.title = title
        self.message = message
        self.onSubmit = onSubmit
        self.onLater = onLater
    }

    public var body: some View {
        VStack(spacing: AppSpacing.medium.rawValue) {
            VStack(spacing: AppSpacing.xSmall.rawValue) {
                Text(title)
                    .font(.app(.title3, weight: .bold))
                    .foregroundColor(.app(.textPrimary))
                Text(message)
                    .font(.app(.body))
                    .foregroundColor(.app(.textSecondary))
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, AppSpacing.medium.rawValue)

            HStack(spacing: AppSpacing.small.rawValue) {
                ForEach(1...5, id: \.self) { index in
                    Image(systemName: index <= rating ? "star.fill" : "star")
                        .foregroundColor(.app(.accent))
                        .font(.system(size: 28))
                        .onTapGesture {
                            rating = index
                            #if canImport(UIKit)
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            #endif
                        }
                        .accessibilityLabel("\(index) star")
                }
            }

            AppButton("Submit", style: .primary) {
                onSubmit(rating)
            }
            .disabled(rating == 0)

            Button("Maybe later") { onLater() }
                .font(.app(.caption))
                .foregroundColor(.app(.textSecondary))
        }
        .padding(AppSpacing.large.rawValue)
        .background(Color.app(.backgroundSecondary))
        .appCornerRadius(AppRadius.large)
        .appShadow(.medium)
    }
}

#if DEBUG
struct RatingPromptView_Previews: PreviewProvider {
    static var previews: some View {
        RatingPromptView(onSubmit: { _ in }, onLater: {})
            .appPadding(AppSpacing.medium)
    }
}
#endif
