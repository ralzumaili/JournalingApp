////
//  SplashView.swift
//  JournalingApp
//
//  ✦ Created by Rawa on 30/05/1448 AH.
//

import SwiftUI

// MARK: - Splash Screen
/// Displays the Journali illustration, name, and tagline.

struct SplashView: View {

    // MARK: - Layout

    private enum Layout {
        static let illustrationWidth: CGFloat = 82
        static let illustrationSpacing: CGFloat = 24
        static let textSpacing: CGFloat = 12
        static let horizontalPadding: CGFloat = 24
        static let bottomPadding: CGFloat = 40
    }

    // MARK: - View Body

    var body: some View {
        VStack(spacing: Layout.illustrationSpacing) {
            Image(.splashIllustration)
                .resizable()
                .scaledToFit()
                .frame(width: Layout.illustrationWidth)
                .accessibilityHidden(true)

            brandText
        }
        .padding(.horizontal, Layout.horizontalPadding)
        .padding(.bottom, Layout.bottomPadding)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background { splashBackground.ignoresSafeArea() }
        .statusBarHidden(true)
    }

    // MARK: - Brand Text

    private var brandText: some View {
        VStack(spacing: Layout.textSpacing) {
            Text("Journali")
                .font(AppTheme.Typography.display)
                .foregroundStyle(AppTheme.Colors.textPrimary)
                .accessibilityAddTraits(.isHeader)

            Text("Your thoughts, your story")
                .font(AppTheme.Typography.supportingBody)
                .foregroundStyle(AppTheme.Colors.textPrimary.opacity(0.85))
        }
        .multilineTextAlignment(.center)
    }

    // MARK: - Background
    /// Recreates the dark gradient sampled from the splash reference.
    
    private var splashBackground: LinearGradient {
        LinearGradient(
            colors: [
                AppTheme.Colors.background,
                Color(red: 10.0 / 255, green: 10.0 / 255, blue: 16.0 / 255),
                Color(red: 21.0 / 255, green: 21.0 / 255, blue: 23.0 / 255)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

// MARK: - Preview

#Preview {
    SplashView()
}
