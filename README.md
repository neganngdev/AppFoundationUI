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
