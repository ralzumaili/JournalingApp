////
//  JournalCardView.swift
//  JournalingApp
//
//  ✦ Created by Rawa on 30/05/1448 AH.
//

import SwiftUI

// MARK: - Journal Card
/// Shows a saved entry with separate controls for opening and bookmarking it.

struct JournalCardView: View {
    let display: JournalDisplayData
    let onOpen: () -> Void
    let onToggleBookmark: () -> Void

    // MARK: - Layout

    private enum Layout {
        static let padding: CGFloat = 24
        static let cornerRadius: CGFloat = 28
        static let bookmarkSize: CGFloat = 44
        static let bookmarkInset: CGFloat = 12
    }

    // MARK: - View Body

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button(action: onOpen) {
                cardContent
                    .contentShape(RoundedRectangle(cornerRadius: Layout.cornerRadius))
            }
            .buttonStyle(.plain)

            bookmarkButton
                .padding(Layout.bookmarkInset)
        }
        .background(
            AppTheme.Colors.card,
            in: RoundedRectangle(cornerRadius: Layout.cornerRadius)
        )
    }

    // MARK: - Card Content

    private var cardContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 6) {
                JournalHighlightedText(display: display.title)
                .font(AppTheme.Typography.cardTitle)
                .foregroundStyle(AppTheme.Colors.textAccent)

                Text(display.createdAt, format: .dateTime.day(.twoDigits).month(.twoDigits).year())
                    .font(AppTheme.Typography.smallCaption)
                    .foregroundStyle(AppTheme.Colors.textSecondary)
            }
            .padding(.trailing, Layout.bookmarkSize)

            if !display.content.text.isEmpty {
                JournalHighlightedText(display: display.content)
                    .font(AppTheme.Typography.mediumBody)
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                    .lineLimit(5)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Layout.padding)
    }

    // MARK: - Bookmark Control

    private var bookmarkButton: some View {
        Button(action: onToggleBookmark) {
            Image(systemName: display.isBookmarked ? "bookmark.fill" : "bookmark")
                .font(AppTheme.Typography.cardTitle)
                .foregroundStyle(AppTheme.Colors.textAccent)
                .frame(width: Layout.bookmarkSize, height: Layout.bookmarkSize)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(display.isBookmarked ? "Remove Bookmark" : "Bookmark Journal")
    }
}
