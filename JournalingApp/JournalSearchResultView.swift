////
//  JournalSearchResultView.swift
//  JournalingApp
//
//  ✦ Created by Rawa on 30/05/1448 AH.
//

import SwiftUI

// MARK: - Full Search Result
/// Shows the complete entry with the query captured when the result was opened.

struct JournalSearchResultView: View {
    let entry: JournalEntry
    let search: JournalSearch

    // MARK: - View Body

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                JournalHighlightedText(
                    text: entry.title.isEmpty ? "Untitled" : entry.title,
                    search: search
                )
                .font(AppTheme.Typography.largeHeading)
                .foregroundStyle(AppTheme.Colors.textAccent)
                .accessibilityAddTraits(.isHeader)

                Text(entry.createdAt, format: .dateTime.day(.twoDigits).month(.twoDigits).year())
                    .font(AppTheme.Typography.smallCaption)
                    .foregroundStyle(AppTheme.Colors.textSecondary)

                JournalHighlightedText(text: entry.content, search: search)
                    .font(AppTheme.Typography.mediumBody)
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                    .textSelection(.enabled)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
        }
        .background(AppTheme.Colors.background.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Highlighted Text
/// Styles every matching range while keeping the original text intact.

struct JournalHighlightedText: View {
    let text: String
    let search: JournalSearch

    var body: some View {
        Text(highlightedText)
    }

    private var highlightedText: AttributedString {
        var result = AttributedString(text)

        for match in search.ranges(in: text) {
            guard let range = Range(match, in: result) else { continue }
            result[range].backgroundColor = AppTheme.Colors.textAccent
            result[range].foregroundColor = AppTheme.Colors.background
        }

        return result
    }
}
