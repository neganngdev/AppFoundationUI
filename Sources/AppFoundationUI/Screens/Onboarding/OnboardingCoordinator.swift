import Foundation

public enum OnboardingCoordinator {
    private static let hasSeenKey = "com.appfoundationui.onboarding.hasSeen"

    public static var hasSeenOnboarding: Bool {
        UserDefaults.standard.bool(forKey: hasSeenKey)
    }

    public static func setHasSeen(_ value: Bool = true) {
        UserDefaults.standard.set(value, forKey: hasSeenKey)
    }

    public static var storageKey: String { hasSeenKey }
}
