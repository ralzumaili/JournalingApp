////
//  JournalViewModel.swift
//  JournalingApp
//
//  ✦ Created by Rawa on 30/05/1448 AH.
//

import Foundation
import SwiftData

// MARK: - Journal List Options

enum JournalFilter: String, CaseIterable {
    case all = "All Journals"
    case bookmarked = "Bookmarked Only"
}

enum JournalSort: String, CaseIterable {
    case newestFirst = "Newest First"
    case oldestFirst = "Oldest First"
}

// MARK: - Journal Display Data
/// Prepares an entry for display without depending on SwiftUI.

struct JournalDisplayData {
    struct HighlightedText {
        let text: String
        let matches: [Range<String.Index>]

        init(_ text: String, matching search: JournalSearch) {
            self.text = text
            matches = search.ranges(in: text)
        }
    }

    let title: HighlightedText
    let content: HighlightedText
    let createdAt: Date
    let isBookmarked: Bool

    init(entry: JournalEntry, search: JournalSearch, showsExcerpt: Bool) {
        title = HighlightedText(entry.title.isEmpty ? "Untitled" : entry.title, matching: search)
        let text = showsExcerpt ? search.excerpt(from: entry.content) : entry.content
        content = HighlightedText(text, matching: search)
        createdAt = entry.createdAt
        isBookmarked = entry.isBookmarked
    }
}

// MARK: - Journal View Model

/// Filters entries for display and persists journal changes.
@MainActor
struct JournalViewModel {
    let modelContext: ModelContext

    // MARK: - Validation

    private enum SaveError: Error {
        case emptyDraft
    }

    static func canSave(_ draft: JournalDraft) -> Bool {
        !draft.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            || !draft.content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    // MARK: - Editor Rules

    static func hasUnsavedChanges(_ draft: JournalDraft, comparedTo original: JournalDraft) -> Bool {
        draft != original
    }

    static func canSaveChanges(_ draft: JournalDraft, comparedTo original: JournalDraft) -> Bool {
        hasUnsavedChanges(draft, comparedTo: original) && canSave(draft)
    }

    // MARK: - Filter and Sort

    static func visibleEntries(
        _ entries: [JournalEntry],
        matching query: JournalSearch,
        filter: JournalFilter,
        sort: JournalSort
    ) -> [JournalEntry] {
        let candidates = filter == .bookmarked ? entries.filter(\.isBookmarked) : entries
        return search(candidates, using: query).sorted { first, second in
            switch sort {
            case .newestFirst:
                first.createdAt > second.createdAt
            case .oldestFirst:
                first.createdAt < second.createdAt
            }
        }
    }

    // MARK: - Journal List State

    enum ListState {
        case noSearchResults(term: String)
        case emptyJournal
        case noBookmarks
        case entries([JournalEntry])
    }

    static func listState(
        for entries: [JournalEntry],
        matching query: JournalSearch,
        filter: JournalFilter,
        sort: JournalSort
    ) -> ListState {
        let results = visibleEntries(entries, matching: query, filter: filter, sort: sort)

        if !results.isEmpty { return .entries(results) }
        if query.isActive { return .noSearchResults(term: query.term) }
        return entries.isEmpty ? .emptyJournal : .noBookmarks
    }

    // MARK: - Save Entry

    func save(_ draft: JournalDraft, editing entry: JournalEntry?, createdAt: Date) throws {
        guard Self.canSave(draft) else { throw SaveError.emptyDraft }

        let title = draft.title.trimmingCharacters(in: .whitespacesAndNewlines)

        if let entry {
            entry.title = title
            entry.content = draft.content
        } else {
            modelContext.insert(JournalEntry(
                title: title,
                content: draft.content,
                createdAt: createdAt
            ))
        }

        try saveChanges()
    }

    // MARK: - Delete Entry

    func delete(_ entry: JournalEntry) throws {
        modelContext.delete(entry)
        try saveChanges()
    }

    // MARK: - Bookmark

    func toggleBookmark(for entry: JournalEntry) throws {
        entry.isBookmarked.toggle()
        try saveChanges()
    }

    // MARK: - Persistence

    private func saveChanges() throws {
        do {
            try modelContext.save()
        } catch {
            // Restore the last saved state if the write fails.
            modelContext.rollback()
            throw error
        }
    }
}
