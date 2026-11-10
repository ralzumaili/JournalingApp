////
//  JournalCardView.swift
//  JournalingApp
//
//  ✦ Created by Rawa on 30/05/1448 AH.
//

import SwiftUI

// MARK: - Journal Card

/// Shows a short preview of a saved entry.
struct JournalCardView: View {
    let entry: JournalEntry
    var search = JournalSearch()

    // MARK: - View Body

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 6) {
                JournalHighlightedText(
                    text: entry.title.isEmpty ? "Untitled" : entry.title,
                    search: search
                )
                .font(AppTheme.Typography.cardTitle)
                .foregroundStyle(AppTheme.Colors.textAccent)

                Text(entry.createdAt, format: .dateTime.day(.twoDigits).month(.twoDigits).year())
                    .font(AppTheme.Typography.smallCaption)
                    .foregroundStyle(AppTheme.Colors.textSecondary)
            }

            if !entry.content.isEmpty {
                JournalHighlightedText(text: search.excerpt(from: entry.content), search: search)
                    .font(AppTheme.Typography.mediumBody)
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                    .lineLimit(5)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .background(AppTheme.Colors.card, in: RoundedRectangle(cornerRadius: 28))
    }
}
