////
//  JournalViewModel.swift
//  JournalingApp
//
//  ✦ Created by Rawa on 30/05/1448 AH.
//

import Foundation
import SwiftData

// MARK: - Journal View Model

/// Validates and persists journal changes on the main context.
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
