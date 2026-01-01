import SwiftUI

struct ComponentsView: View {
    @State private var email: String = ""
    @State private var bio: String = ""
    @State private var notifications: Bool = true
    @State private var city = DemoCity.london

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.large.rawValue) {
                buttons
                cards
                forms
            }
            .appPadding(AppSpacing.medium)
        }
        .background(Color.app(.backgroundPrimary))
    }

    private var buttons: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small.rawValue) {
            Text("Buttons").font(.app(.headline, weight: .bold))
            AppButton("Primary") {}
            AppButton("Secondary", style: .secondary) {}
            AppButton("Tertiary", style: .tertiary) {}
            AppButton("Destructive", style: .destructive) {}
        }
    }

    private var cards: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small.rawValue) {
            Text("Card").font(.app(.headline, weight: .bold))
            AppCard {
                Text("Card content")
                    .font(.app(.body))
            }
        }
    }

    private var forms: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small.rawValue) {
            Text("Forms").font(.app(.headline, weight: .bold))
            AppTextField(text: $email, placeholder: "Email", icon: "envelope", validation: .email)
            AppTextEditor(text: $bio, placeholder: "Tell us about yourself", characterLimit: 140)
            AppToggle(isOn: $notifications, title: "Push Notifications", description: "Receive updates")
            AppPicker(title: "City", selection: $city, items: DemoCity.all, style: .menu)
        }
    }
}

private struct DemoCity: Identifiable, Hashable, CustomStringConvertible {
    let id = UUID()
    let name: String
    var description: String { name }

    static let london = DemoCity(name: "London")
    static let paris = DemoCity(name: "Paris")
    static let newYork = DemoCity(name: "New York")
    static let all = [london, paris, newYork]
}

#if DEBUG
struct ComponentsView_Previews: PreviewProvider {
    static var previews: some View {
        ComponentsView()
    }
}
#endif
