import SwiftUI

public struct BottomSheet<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let detents: Set<PresentationDetent>
    let showDragIndicator: Bool
    let prefersGrabber: Bool
    let content: () -> SheetContent

    public init(isPresented: Binding<Bool>,
                detents: Set<PresentationDetent> = [.medium, .large],
                showDragIndicator: Bool = true,
                prefersGrabber: Bool = true,
                @ViewBuilder content: @escaping () -> SheetContent) {
        self._isPresented = isPresented
        self.detents = detents
        self.showDragIndicator = showDragIndicator
        self.prefersGrabber = prefersGrabber
        self.content = content
    }

    public func body(content base: Content) -> some View {
        base.sheet(isPresented: $isPresented) {
            if #available(iOS 16.0, macOS 13.3, *) {
                self.content()
                    .presentationDetents(detents)
                    .presentationDragIndicator(showDragIndicator ? .visible : .hidden)
                    .presentationCornerRadius(AppRadius.large.rawValue)
                    .presentationBackgroundInteraction(.automatic)
            } else {
                self.content()
            }
        }
    }
}

public extension View {
    func bottomSheet<SheetContent: View>(isPresented: Binding<Bool>,
                                         detents: Set<PresentationDetent> = [.medium, .large],
                                         showDragIndicator: Bool = true,
                                         prefersGrabber: Bool = true,
                                         @ViewBuilder content: @escaping () -> SheetContent) -> some View {
        modifier(BottomSheet(isPresented: isPresented,
                             detents: detents,
                             showDragIndicator: showDragIndicator,
                             prefersGrabber: prefersGrabber,
                             content: content))
    }
}
