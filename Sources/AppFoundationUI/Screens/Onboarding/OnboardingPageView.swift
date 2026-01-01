import SwiftUI

public struct OnboardingPageView: View {
    public let page: OnboardingPage

    public init(page: OnboardingPage) {
        self.page = page
    }

    public var body: some View {
        VStack(spacing: AppSpacing.large.rawValue) {
            Spacer()

            if let icon = page.icon {
                Image(systemName: icon)
                    .font(.system(size: 64, weight: .semibold))
                    .foregroundColor(.app(.accent))
                    .accessibilityHidden(true)
            } else if let imageName = page.imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 200)
                    .accessibilityHidden(true)
            }

            VStack(spacing: AppSpacing.small.rawValue) {
                Text(page.title)
                    .font(.app(.largeTitle, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.app(.textPrimary))
                Text(page.description)
                    .font(.app(.body))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.app(.textSecondary))
            }
            .padding(.horizontal, AppSpacing.large.rawValue)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(page.backgroundColor)
    }
}

#if DEBUG
struct OnboardingPageView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPageView(page: OnboardingPage(icon: "sparkles",
                                                title: "Welcome",
                                                description: "Get started with AppFoundationUI"))
    }
}
#endif
