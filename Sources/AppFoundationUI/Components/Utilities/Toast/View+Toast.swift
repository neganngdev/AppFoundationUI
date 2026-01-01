import SwiftUI

public struct ToastPresenter: ViewModifier {
    @ObservedObject var manager: ToastManager
    @State private var offset: CGFloat = -200

    public func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            content
            if let toast = manager.currentToast {
                ToastView(toast: toast)
                    .padding(.top, AppSpacing.large.rawValue)
                    .padding(.horizontal, AppSpacing.medium.rawValue)
                    .offset(y: offset)
                    .onAppear {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.9)) {
                            offset = 0
                        }
                    }
                    .gesture(DragGesture().onEnded { value in
                        if value.translation.height < -20 {
                            dismiss()
                        }
                    })
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .onTapGesture { dismiss() }
            }
        }
        .onChange(of: manager.currentToast != nil) { _ in
            if manager.currentToast == nil {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                    offset = -200
                }
            } else {
                offset = -200
            }
        }
    }

    private func dismiss() {
        withAnimation(.easeInOut) {
            offset = -200
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            manager.dismissCurrent()
        }
    }
}

public extension View {
    func toast(manager: ToastManager) -> some View {
        modifier(ToastPresenter(manager: manager))
    }
}
