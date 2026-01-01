import SwiftUI
#if canImport(UIKit)
import StoreKit
#endif

public actor RatingManager {
    public static let shared = RatingManager()

    private let defaults = UserDefaults.standard
    private let launchKey = "appfoundationui.rating.launchCount"
    private let actionKey = "appfoundationui.rating.actionCount"
    private let lastPromptKey = "appfoundationui.rating.lastPrompt"

    private let minLaunches = 3
    private let minActions = 5
    private let minDaysBetweenPrompts: Double = 30

    public func trackLaunch() {
        let count = defaults.integer(forKey: launchKey) + 1
        defaults.set(count, forKey: launchKey)
    }

    public func trackAction() {
        let count = defaults.integer(forKey: actionKey) + 1
        defaults.set(count, forKey: actionKey)
    }

    public func shouldPrompt() -> Bool {
        let launches = defaults.integer(forKey: launchKey)
        let actions = defaults.integer(forKey: actionKey)
        guard launches >= minLaunches && actions >= minActions else { return false }
        if let last = defaults.object(forKey: lastPromptKey) as? Date {
            let days = Date().timeIntervalSince(last) / (60 * 60 * 24)
            if days < minDaysBetweenPrompts { return false }
        }
        return true
    }

    #if canImport(UIKit)
    public func requestReviewIfAppropriate(in scene: UIWindowScene?) {
        guard shouldPrompt() else { return }
        defaults.set(Date(), forKey: lastPromptKey)
        if let scene { SKStoreReviewController.requestReview(in: scene) }
    }
    #endif
}
