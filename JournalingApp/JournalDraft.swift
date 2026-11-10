////
//  JournalDraft.swift
//  JournalingApp
//
//  ✦ Created by Rawa on 30/05/1448 AH.
//

// MARK: - Journal Draft

/// Holds a temporary copy of the journal fields while the user edits.
struct JournalDraft: Equatable {

    // MARK: - Editable Fields

    var title: String = ""
    var content: String = ""
}
