import SwiftUI

public struct PullToRefresh: ViewModifier {
    let action: () async -> Void

    public func body(content: Content) -> some View {
        content
            .refreshable {
                #if canImport(UIKit)
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                #endif
                await action()
            }
    }
}

public extension View {
    func pullToRefresh(_ action: @escaping () async -> Void) -> some View {
        modifier(PullToRefresh(action: action))
    }
}
