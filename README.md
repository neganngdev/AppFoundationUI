# AppFoundationUI

SwiftUI design system package that complements `AppFoundation` with reusable UI tokens and modifiers.

## Requirements

- iOS 16.0+
- macOS 13.0+
- Swift Package Manager

## Installation

Add the package to your project and include the local dependency on AppFoundation.

```swift
// Package.swift
.package(path: "../AppFoundation"),
.package(path: "../AppFoundationUI")
```

## Usage

```swift
import SwiftUI
import AppFoundationUI

struct ContentView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: .app(AppSpacing.medium)) {
            Text("Hello")
                .font(.app(.headline))
                .foregroundColor(.app(.textPrimary))

            Text("Supporting text")
                .font(.app(.body))
                .foregroundColor(.app(.textSecondary))
        }
        .appPadding(AppSpacing.medium)
        .appBackground(.backgroundPrimary)
    }
}
```

## Design System

### Colors

```swift
Text("Primary")
    .foregroundColor(.app(.primary))
```

### Typography

```swift
Text("Title")
    .font(.app(.title, weight: .bold))

Text("Custom font")
    .font(.app(.headline, customFontName: "YourCustomFont"))
```

### Spacing

```swift
VStack(spacing: .app(AppSpacing.large)) {
    Text("Item")
}
```

### Radius & Shadow

```swift
RoundedRectangle(cornerRadius: .app(AppRadius.medium))
    .fill(Color.app(.backgroundSecondary))
    .appShadow(.medium)
```

### Theme Injection

```swift
struct MyTheme: ThemeProvider {
    func color(_ token: AppColors.Token) -> Color { .app(token) }
    func font(_ style: AppFonts.TextStyle, weight: AppFonts.Weight) -> Font {
        AppFonts.font(style, weight: weight, customFontName: "YourCustomFont")
    }
    func spacing(_ value: AppSpacing.Value) -> CGFloat { value.rawValue }
    func radius(_ value: AppRadius.Value) -> CGFloat { value.rawValue }
    func shadow(_ style: AppShadow.Style) -> AppShadow.Elevation { AppShadow.elevation(style) }
}

ContentView()
    .appTheme(MyTheme())
```

## Components

### Buttons

```swift
Button("Submit") { }
    .buttonStyle(.appPrimary())

AppButton("Delete", style: .destructive) { }
```

### Cards

```swift
AppCard {
    Text("Content")
}
```

### Loading

```swift
AppLoadingView(message: "Loading data")
AppProgressView(title: "Sync", value: 0.6)
SkeletonView(height: 16, width: 180)
```

### Empty State

```swift
EmptyStateView(configuration: EmptyStatePreset.noResults.configuration)
```

### Error State

```swift
ErrorStateView(message: "Unable to refresh data") {
    // retry
}
```

### Form Inputs

```swift
AppTextField(
    text: $email,
    placeholder: "Email",
    icon: "envelope",
    validation: .email
)

AppTextEditor(
    text: $bio,
    placeholder: "Tell us about yourself",
    characterLimit: 500
)

AppToggle(
    isOn: $notifications,
    title: "Push Notifications",
    description: "Receive updates"
)

AppPicker(
    title: "City",
    selection: $city,
    items: cities,
    style: .sheet,
    showsSearch: true
)
```

### Validation

```swift
let validator = FormValidator()
let result = validator.validate("user@example.com", using: .email)

// Custom rule
struct OnlySwift: ValidationRule {
    func validate(_ value: String) -> ValidationResult {
        value.contains("swift") ? .success : .failure(message: "Must include swift")
    }
}
let customResult = validator.validate("swift rocks", using: .custom(OnlySwift()))
```

### Onboarding

```swift
let pages = [
    OnboardingPage(icon: "star.fill", title: "Welcome", description: "Get started with our app"),
    OnboardingPage(icon: "bell.fill", title: "Stay Updated", description: "Never miss important updates")
]

OnboardingContainerView(pages: pages) {
    // completed or skipped
}
```

## Structure

```
Sources/AppFoundationUI/
  DesignSystem/
  Components/
  Screens/
  Utilities/
Tests/AppFoundationUITests/
```

## Tokens

- Colors: `primary`, `secondary`, `accent`, background, text, semantic, border, separator
- Fonts: `largeTitle`, `title`, `title2`, `title3`, `headline`, `subheadline`, `body`, `callout`, `caption`, `footnote`
- Spacing: `xxxSmall` (2), `xxSmall` (4), `xSmall` (8), `small` (12), `medium` (16), `large` (24), `xLarge` (32), `xxLarge` (48)
- Radius: `small` (4), `medium` (8), `large` (12), `xLarge` (16)
- Shadow: `small`, `medium`, `large`

## Development

```bash
swift build
```
