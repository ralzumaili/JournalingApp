////
//  JournalViewModel.swift
//  JournalingApp
//
//  ✦ Created by Rawa on 30/05/1448 AH.
//

import Foundation
import SwiftData

// MARK: - Journal View Model

/// Applies validation and saves journal changes on the main context.
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

        do {
            try modelContext.save()
        } catch {
            // Restore the stored entry or remove the pending insert if saving fails.
            modelContext.rollback()
            throw error
        }
    }
}
