import SwiftUI

public struct DemoAppView: View {
    public init() {}

    public var body: some View {
        TabView {
            DesignSystemView()
                .tabItem { Label("Design", systemImage: "paintpalette") }
            ComponentsView()
                .tabItem { Label("Components", systemImage: "square.grid.2x2") }
            OnboardingDemoView()
                .tabItem { Label("Onboarding", systemImage: "sparkles") }
            PaywallDemoView()
                .tabItem { Label("Paywall", systemImage: "creditcard") }
            PermissionsDemoView()
                .tabItem { Label("Permissions", systemImage: "bell.badge") }
            UtilitiesDemoView()
                .tabItem { Label("Utilities", systemImage: "wand.and.stars") }
        }
    }
}

#if DEBUG
struct DemoAppView_Previews: PreviewProvider {
    static var previews: some View {
        DemoAppView()
    }
}
#endif
