import SwiftUI

@MainActor
public final class ToastManager: ObservableObject {
    @Published public private(set) var currentToast: Toast?
    private var queue: [Toast] = []
    private var timer: Timer?

    public init() {}

    public func show(_ toast: Toast) {
        queue.append(toast)
        if currentToast == nil {
            presentNext()
        }
    }

    public func dismissCurrent() {
        timer?.invalidate()
        timer = nil
        currentToast = nil
        presentNext()
    }

    private func presentNext() {
        guard currentToast == nil, !queue.isEmpty else { return }
        currentToast = queue.removeFirst()
        provideHaptic(for: currentToast?.type)
        timer = Timer.scheduledTimer(withTimeInterval: currentToast?.duration ?? 2.5, repeats: false) { [weak self] _ in
            self?.currentToast = nil
            self?.presentNext()
        }
    }

    private func provideHaptic(for type: ToastType?) {
        #if canImport(UIKit)
        guard let type else { return }
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        switch type {
        case .success: generator.notificationOccurred(.success)
        case .error: generator.notificationOccurred(.error)
        case .warning, .info: generator.notificationOccurred(.warning)
        }
        #endif
    }
}
