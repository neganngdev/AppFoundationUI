import SwiftUI

public struct PermissionRequest: Identifiable, Hashable, Sendable {
    public let id = UUID()
    public let icon: String
    public let title: String
    public let description: String
    public let type: PermissionType

    public init(icon: String,
                title: String,
                description: String,
                type: PermissionType) {
        self.icon = icon
        self.title = title
        self.description = description
        self.type = type
    }
}
