import Foundation

public enum PermissionType: String, CaseIterable, Identifiable, Sendable {
    public var id: String { rawValue }

    case notifications
    case tracking
    case camera
    case photos
    case microphone
    case locationWhenInUse
    case locationAlways

    public var displayName: String {
        switch self {
        case .notifications: return "Notifications"
        case .tracking: return "App Tracking"
        case .camera: return "Camera"
        case .photos: return "Photos"
        case .microphone: return "Microphone"
        case .locationWhenInUse: return "Location (While Using)"
        case .locationAlways: return "Location (Always)"
        }
    }

    public var systemIcon: String {
        switch self {
        case .notifications: return "bell.badge"
        case .tracking: return "hand.point.up.left"
        case .camera: return "camera.fill"
        case .photos: return "photo.on.rectangle"
        case .microphone: return "mic.fill"
        case .locationWhenInUse, .locationAlways: return "location.fill"
        }
    }
}

public enum PermissionStatus: Equatable, Sendable {
    case authorized
    case denied
    case notDetermined
    case restricted
    case notSupported
}
