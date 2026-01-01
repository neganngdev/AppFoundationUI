import SwiftUI

public enum AppPickerStyleVariant {
    case menu
    case sheet
}

public struct AppPicker<Item: Identifiable & Hashable & CustomStringConvertible>: View {
    @Binding private var selection: Item
    @State private var isPresented = false
    @State private var query = ""

    private let title: String
    private let items: [Item]
    private let style: AppPickerStyleVariant
    private let showsSearch: Bool

    public init(title: String,
                selection: Binding<Item>,
                items: [Item],
                style: AppPickerStyleVariant = .menu,
                showsSearch: Bool = false) {
        self.title = title
        self._selection = selection
        self.items = items
        self.style = style
        self.showsSearch = showsSearch
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xSmall.rawValue) {
            Text(title)
                .font(.app(.caption, weight: .medium))
                .foregroundColor(.app(.textSecondary))

            switch style {
            case .menu:
                Menu {
                    ForEach(items) { item in
                        Button(item.description) { selection = item }
                    }
                } label: {
                    pickerLabel
                }
            case .sheet:
                Button {
                    isPresented.toggle()
                } label: {
                    pickerLabel
                }
                .sheet(isPresented: $isPresented) {
                    NavigationView {
                        List(filteredItems) { item in
                            Button {
                                selection = item
                                isPresented = false
                            } label: {
                                HStack {
                                    Text(item.description)
                                        .foregroundColor(.app(.textPrimary))
                                    if item == selection {
                                        Spacer()
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.app(.primary))
                                    }
                                }
                            }
                        }
                        .modifier(SearchableModifier(enabled: showsSearch, query: $query))
                        .navigationTitle(title)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Done") { isPresented = false }
                            }
                        }
                    }
                }
            }
        }
    }

    private var pickerLabel: some View {
        HStack {
            Text(selection.description)
                .font(.app(.body))
                .foregroundColor(.app(.textPrimary))
            Spacer()
            Image(systemName: "chevron.down")
                .foregroundColor(.app(.textTertiary))
        }
        .padding(.horizontal, AppSpacing.small.rawValue)
        .padding(.vertical, AppSpacing.xSmall.rawValue)
        .frame(maxWidth: .infinity)
        .background(Color.app(.backgroundSecondary))
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.medium.rawValue)
                .stroke(Color.app(.border), lineWidth: 1)
        )
        .cornerRadius(AppRadius.medium.rawValue)
    }

    private var filteredItems: [Item] {
        guard showsSearch, !query.isEmpty else { return items }
        return items.filter { $0.description.localizedCaseInsensitiveContains(query) }
    }
}

#if DEBUG
private struct City: Identifiable, Hashable, CustomStringConvertible {
    let id = UUID()
    let name: String
    var description: String { name }
}

struct AppPicker_Previews: PreviewProvider {
    static var previews: some View {
        PreviewState(initialValue: City(name: "London")) { selection in
            AppPicker(title: "City",
                      selection: selection,
                      items: [City(name: "London"), City(name: "Paris"), City(name: "New York")],
                      style: .sheet,
                      showsSearch: true)
            .appPadding(AppSpacing.medium)
            .previewDisplayName("AppPicker")
        }
    }
}

private struct PreviewState<Value, Content: View>: View {
    @State private var value: Value
    private let content: (Binding<Value>) -> Content

    init(initialValue: Value, @ViewBuilder content: @escaping (Binding<Value>) -> Content) {
        self._value = State(initialValue: initialValue)
        self.content = content
    }

    var body: some View {
        content($value)
    }
}

private struct SearchableModifier: ViewModifier {
    let enabled: Bool
    @Binding var query: String

    func body(content: Content) -> some View {
        if enabled {
            content.searchable(text: $query, prompt: "Search")
        } else {
            content
        }
    }
}

#endif
