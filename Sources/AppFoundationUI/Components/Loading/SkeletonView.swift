import SwiftUI

public struct SkeletonView: View {
    private let cornerRadius: AppRadius.Value
    private let height: CGFloat
    private let width: CGFloat?

    public init(height: CGFloat,
                width: CGFloat? = nil,
                cornerRadius: AppRadius.Value = AppRadius.medium) {
        self.height = height
        self.width = width
        self.cornerRadius = cornerRadius
    }

    public var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius.rawValue)
            .fill(Color.app(.backgroundTertiary))
            .frame(width: width, height: height)
            .modifier(ShimmerModifier())
            .accessibilityHidden(true)
    }
}

private struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .overlay(shimmerMask)
            .onAppear {
                withAnimation(.linear(duration: 1.2).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }

    private var shimmerMask: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let offset = (width * 1.5) * phase
            LinearGradient(gradient: Gradient(colors: [
                Color.white.opacity(0.0),
                Color.white.opacity(0.35),
                Color.white.opacity(0.0)
            ]), startPoint: .leading, endPoint: .trailing)
            .frame(width: width * 1.5)
            .offset(x: offset - width)
            .blendMode(.screen)
        }
    }
}

#if DEBUG
struct SkeletonView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: AppSpacing.small.rawValue) {
            SkeletonView(height: 16, width: 140)
            SkeletonView(height: 16, width: 220)
            SkeletonView(height: 80)
        }
        .appPadding(AppSpacing.medium)
        .previewDisplayName("SkeletonView")
    }
}
#endif
