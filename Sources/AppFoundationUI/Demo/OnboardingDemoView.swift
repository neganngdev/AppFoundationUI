import SwiftUI

struct OnboardingDemoView: View {
    private let pages: [OnboardingPage] = [
        OnboardingPage(icon: "sparkles", title: "Welcome", description: "Get started with AppFoundationUI"),
        OnboardingPage(icon: "bell.fill", title: "Stay Updated", description: "Never miss important updates"),
        OnboardingPage(icon: "hand.thumbsup.fill", title: "Ready", description: "You are all set!")
    ]

    var body: some View {
        OnboardingContainerView(pages: pages) {}
            .background(Color.app(.backgroundPrimary))
    }
}

#if DEBUG
struct OnboardingDemoView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingDemoView()
    }
}
#endif
