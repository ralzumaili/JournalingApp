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

    // MARK: - Create Entry

    func add(_ draft: JournalDraft, createdAt: Date) throws {
        guard Self.canSave(draft) else { throw SaveError.emptyDraft }

        let entry = JournalEntry(
            title: draft.title.trimmingCharacters(in: .whitespacesAndNewlines),
            content: draft.content,
            createdAt: createdAt
        )
        modelContext.insert(entry)

        do {
            try modelContext.save()
        } catch {
            // Remove the pending insert so the user can retry the same draft.
            modelContext.rollback()
            throw error
        }
    }
}
