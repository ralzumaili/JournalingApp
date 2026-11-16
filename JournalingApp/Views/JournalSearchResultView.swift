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
    let display: JournalDisplayData

    // MARK: - View Body

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                JournalHighlightedText(display: display.title)
                .font(AppTheme.Typography.largeHeading)
                .foregroundStyle(AppTheme.Colors.textAccent)
                .accessibilityAddTraits(.isHeader)

                Text(display.createdAt, format: .dateTime.day(.twoDigits).month(.twoDigits).year())
                    .font(AppTheme.Typography.smallCaption)
                    .foregroundStyle(AppTheme.Colors.textSecondary)

                JournalHighlightedText(display: display.content)
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
    let display: JournalDisplayData.HighlightedText

    var body: some View {
        Text(highlightedText)
    }

    private var highlightedText: AttributedString {
        var result = AttributedString(display.text)

        for match in display.matches {
            guard let range = Range(match, in: result) else { continue }
            result[range].backgroundColor = AppTheme.Colors.textAccent
            result[range].foregroundColor = AppTheme.Colors.background
        }

        return result
    }
}
