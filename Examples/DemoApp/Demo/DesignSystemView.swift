import SwiftUI

struct DesignSystemView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.large.rawValue) {
                colorsSection
                typographySection
                spacingSection
                radiusShadowSection
            }
            .appPadding(AppSpacing.medium)
        }
        .background(Color.app(.backgroundPrimary))
    }

    private var colorsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small.rawValue) {
            Text("Colors").font(.app(.headline, weight: .bold))
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: AppSpacing.small.rawValue), count: 2), spacing: AppSpacing.small.rawValue) {
                ForEach(AppColors.Token.allCases, id: \ .self) { token in
                    HStack {
                        RoundedRectangle(cornerRadius: AppRadius.small.rawValue)
                            .fill(Color.app(token))
                            .frame(width: 40, height: 40)
                        Text(String(describing: token))
                            .font(.app(.body))
                    }
                    .appPadding(AppSpacing.xSmall)
                    .background(Color.app(.backgroundSecondary))
                    .appCornerRadius(AppRadius.medium)
                }
            }
        }
    }

    private var typographySection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xSmall.rawValue) {
            Text("Typography").font(.app(.headline, weight: .bold))
            ForEach(AppFonts.TextStyle.allCases, id: \ .self) { style in
                Text(String(describing: style))
                    .font(.app(style, weight: .semibold))
            }
        }
    }

    private var spacingSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xSmall.rawValue) {
            Text("Spacing").font(.app(.headline, weight: .bold))
            ForEach([AppSpacing.xxxSmall, AppSpacing.xxSmall, AppSpacing.xSmall, AppSpacing.small,
                     AppSpacing.medium, AppSpacing.large, AppSpacing.xLarge, AppSpacing.xxLarge],
                    id: \.rawValue) { spacing in
                HStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.app(.accent))
                        .frame(width: spacing.rawValue, height: 8)
                    Text("\(Int(spacing.rawValue))")
                        .font(.app(.caption))
                        .foregroundColor(.app(.textSecondary))
                }
            }
        }
    }

    private var radiusShadowSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small.rawValue) {
            Text("Radius & Shadow").font(.app(.headline, weight: .bold))
            HStack(spacing: AppSpacing.medium.rawValue) {
                ForEach([AppRadius.small, AppRadius.medium, AppRadius.large, AppRadius.xLarge], id: \.rawValue) { radius in
                    RoundedRectangle(cornerRadius: radius.rawValue)
                        .fill(Color.app(.backgroundSecondary))
                        .frame(width: 60, height: 60)
                        .appShadow(.medium)
                }
            }
        }
    }
}

#if DEBUG
struct DesignSystemView_Previews: PreviewProvider {
    static var previews: some View {
        DesignSystemView()
    }
}
#endif
