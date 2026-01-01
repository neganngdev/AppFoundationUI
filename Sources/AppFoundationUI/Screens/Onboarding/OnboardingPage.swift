import SwiftUI

public struct OnboardingPage: Identifiable, Hashable {
    public let id = UUID()
    public let icon: String?
    public let imageName: String?
    public let title: String
    public let description: String
    public let backgroundColor: Color

    public init(icon: String? = nil,
                imageName: String? = nil,
                title: String,
                description: String,
                backgroundColor: Color = .app(.backgroundPrimary)) {
        self.icon = icon
        self.imageName = imageName
        self.title = title
        self.description = description
        self.backgroundColor = backgroundColor
    }
}
