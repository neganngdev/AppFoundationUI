import Foundation
import SwiftUI
#if canImport(UserNotifications)
import UserNotifications
#endif
#if os(iOS)
import AppTrackingTransparency
#endif

@MainActor
public final class PermissionCoordinator: ObservableObject {
    @Published public private(set) var currentIndex: Int = 0
    @Published public private(set) var currentPermission: PermissionType?
    @Published public var isRequesting: Bool = false

    private var queue: [PermissionType]
    private let onComplete: () -> Void

    public init(permissions: [PermissionType], onComplete: @escaping () -> Void) {
        self.queue = permissions
        self.onComplete = onComplete
        advance()
    }

    public func advance() {
        currentPermission = nil
        guard !queue.isEmpty else {
            onComplete()
            return
        }
        currentIndex = 0
        proceedToNextAvailable()
    }

    private func proceedToNextAvailable() {
        guard let next = queue.first else {
            onComplete()
            return
        }
        checkStatus(for: next) { [weak self] status in
            guard let self else { return }
            if status == .authorized || status == .restricted {
                self.queue.removeFirst()
                self.proceedToNextAvailable()
            } else {
                self.currentPermission = next
            }
        }
    }

    public func requestCurrent(completion: (() -> Void)? = nil) {
        guard let permission = currentPermission else { return }
        isRequesting = true
        request(permission) { [weak self] in
            guard let self else { return }
            self.isRequesting = false
            self.queue.removeFirst()
            self.proceedToNextAvailable()
            completion?()
        }
    }

    public func skipCurrent() {
        if !queue.isEmpty { queue.removeFirst() }
        proceedToNextAvailable()
    }

    // MARK: - Status

    private func checkStatus(for permission: PermissionType, completion: @MainActor @escaping (PermissionStatus) -> Void) {
        switch permission {
        case .notifications:
            #if canImport(UserNotifications)
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                let status: PermissionStatus
                switch settings.authorizationStatus {
                case .authorized, .provisional, .ephemeral: status = .authorized
                case .denied: status = .denied
                case .notDetermined: status = .notDetermined
                default: status = .restricted
                }
                DispatchQueue.main.async { completion(status) }
            }
            #else
            completion(.notSupported)
            #endif
        case .tracking:
            #if os(iOS)
            let status = ATTrackingManager.trackingAuthorizationStatus
            switch status {
            case .authorized: completion(.authorized)
            case .denied: completion(.denied)
            case .notDetermined: completion(.notDetermined)
            case .restricted: completion(.restricted)
            @unknown default: completion(.restricted)
            }
            #else
            completion(.notSupported)
            #endif
        default:
            completion(.notDetermined)
        }
    }

    // MARK: - Request

    private func request(_ permission: PermissionType, completion: @MainActor @escaping () -> Void) {
        switch permission {
        case .notifications:
            #if canImport(UserNotifications)
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in
                DispatchQueue.main.async { completion() }
            }
            #else
            completion()
            #endif
        case .tracking:
            #if os(iOS)
            if #available(iOS 14.5, *) {
                ATTrackingManager.requestTrackingAuthorization { _ in
                    DispatchQueue.main.async { completion() }
                }
            } else {
                completion()
            }
            #else
            completion()
            #endif
        default:
            completion()
        }
    }
}
