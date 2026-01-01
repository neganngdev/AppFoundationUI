import SwiftUI

public struct OnboardingContainerView: View {
    private let pages: [OnboardingPage]
    private let onComplete: () -> Void

    @State private var currentIndex: Int = 0
    @AppStorage(OnboardingCoordinator.storageKey) private var hasSeenOnboarding: Bool = false

    public init(pages: [OnboardingPage], onComplete: @escaping () -> Void) {
        self.pages = pages
        self.onComplete = onComplete
    }

    public var body: some View {
        VStack(spacing: 0) {
            header
            pager
            footer
        }
        .background(currentPage.backgroundColor.ignoresSafeArea())
        .animation(.easeInOut, value: currentIndex)
    }

    private var header: some View {
        HStack {
            Spacer()
            Button("Skip") {
                completeOnboarding()
            }
            .font(.app(.body, weight: .semibold))
            .foregroundColor(.app(.textSecondary))
            .padding(.trailing, AppSpacing.medium.rawValue)
            .padding(.top, AppSpacing.medium.rawValue)
            .accessibilityLabel("Skip onboarding")
        }
    }

    private var pager: some View {
        TabView(selection: $currentIndex) {
            ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                OnboardingPageView(page: page)
                    .tag(index)
            }
        }
        #if os(macOS)
        .tabViewStyle(DefaultTabViewStyle())
        #else
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        #endif
    }

    private var footer: some View {
        VStack(spacing: AppSpacing.medium.rawValue) {
            pageIndicator
            AppButton(isLastPage ? "Get Started" : "Continue",
                      style: .primary) {
                handleContinue()
            }
            .padding(.horizontal, AppSpacing.large.rawValue)
            .padding(.bottom, AppSpacing.large.rawValue)
        }
        .background(currentPage.backgroundColor.opacity(0.95).ignoresSafeArea())
    }

    private var pageIndicator: some View {
        HStack(spacing: AppSpacing.xxSmall.rawValue) {
            ForEach(0..<pages.count, id: \.self) { index in
                Circle()
                    .fill(index == currentIndex ? Color.app(.primary) : Color.app(.textTertiary).opacity(0.4))
                    .frame(width: index == currentIndex ? 10 : 8, height: index == currentIndex ? 10 : 8)
                    .animation(.easeInOut(duration: 0.2), value: currentIndex)
            }
        }
        .accessibilityLabel("Page \(currentIndex + 1) of \(pages.count)")
    }

    private var currentPage: OnboardingPage {
        pages.indices.contains(currentIndex) ? pages[currentIndex] : pages.first ?? OnboardingPage(title: "", description: "")
    }

    private var isLastPage: Bool {
        currentIndex == pages.count - 1
    }

    private func handleContinue() {
        if isLastPage {
            completeOnboarding()
        } else {
            withAnimation {
                currentIndex = min(currentIndex + 1, pages.count - 1)
            }
        }
    }

    private func completeOnboarding() {
        hasSeenOnboarding = true
        OnboardingCoordinator.setHasSeen(true)
        onComplete()
    }
}

#if DEBUG
struct OnboardingContainerView_Previews: PreviewProvider {
    static var pages: [OnboardingPage] = [
        OnboardingPage(icon: "sparkles", title: "Welcome", description: "Get started with our app"),
        OnboardingPage(icon: "bell.fill", title: "Stay Updated", description: "Never miss important updates"),
        OnboardingPage(icon: "hand.thumbsup.fill", title: "Ready", description: "You are all set!")
    ]

    static var previews: some View {
        OnboardingContainerView(pages: pages) {}
    }
}
#endif
