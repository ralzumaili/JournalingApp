////
//  JournalEmptyStateView.swift
//  JournalingApp
//
//  ✦ Created by Rawa on 30/05/1448 AH.
//

import SwiftUI

// MARK: - Journal Empty State
/// Introduces the journal when there are no entries.

struct JournalEmptyStateView: View {

    // MARK: - Layout

    private enum Layout {
        static let illustrationWidth: CGFloat = 150
        static let illustrationSpacing: CGFloat = 32
        static let messageSpacing: CGFloat = 16
        static let messageWidth: CGFloat = 300
        static let horizontalPadding: CGFloat = 24
    }

    // MARK: - View Body

    var body: some View {
        VStack(spacing: Layout.illustrationSpacing) {
            Image(.emptyStateIllustration)
                .resizable()
                .scaledToFit()
                .frame(width: Layout.illustrationWidth)
                .accessibilityHidden(true)

            message
        }
        .padding(.horizontal, Layout.horizontalPadding)
    }

    // MARK: - Message

    private var message: some View {
        VStack(spacing: Layout.messageSpacing) {
            Text("Begin Your Journal")
                .font(AppTheme.Typography.mediumHeading)
                .foregroundStyle(AppTheme.Colors.textAccent)
                .accessibilityAddTraits(.isHeader)

            Text("Craft your personal diary, tap the plus icon to begin")
                .font(AppTheme.Typography.supportingBody)
                .foregroundStyle(AppTheme.Colors.textPrimary)
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: Layout.messageWidth)
    }
}
