////
//  JournalEntry.swift
//  JournalingApp
//
//  ✦ Created by Rawa on 30/05/1448 AH.
//

import Foundation
import SwiftData

// MARK: - Journal Entry
/// A journal entry that SwiftData keeps across app launches.

@Model
final class JournalEntry {

    // MARK: - Stored Properties

    var title: String
    var content: String
    private(set) var createdAt: Date
    var isBookmarked: Bool = false

    // MARK: - Initialization

    init(title: String, content: String, createdAt: Date = .now) {
        self.title = title
        self.content = content
        self.createdAt = createdAt
    }
}
