////
//  JournalSearch.swift
//  JournalingApp
//
//  ✦ Created by Rawa on 30/05/1448 AH.
//

import Foundation

// MARK: - Journal Search
/// Shares one matching rule between results, excerpts, and highlights.

struct JournalSearch: Hashable {
    let term: String

    init(_ query: String = "") {
        term = query.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var isActive: Bool { !term.isEmpty }

    // MARK: - Matches

    func firstMatch(in text: String) -> Range<String.Index>? {
        nextMatch(in: text, from: text.startIndex)
    }

    func ranges(in text: String) -> [Range<String.Index>] {
        var matches: [Range<String.Index>] = []
        var start = text.startIndex

        while let match = nextMatch(in: text, from: start) {
            matches.append(match)
            start = match.upperBound
        }

        return matches
    }

    private func nextMatch(in text: String, from start: String.Index) -> Range<String.Index>? {
        guard isActive, start < text.endIndex,
              let match = text.range(
                  of: term,
                  options: [.caseInsensitive, .diacriticInsensitive],
                  range: start..<text.endIndex,
                  locale: .current
              ),
              !match.isEmpty else { return nil }

        return match
    }

    // MARK: - Card Excerpt

    func excerpt(from text: String) -> String {
        guard let match = firstMatch(in: text) else { return text }

        let context = text[..<match.lowerBound].suffix(24)
        let start = context.lastIndex(where: \.isNewline)
            .map { text.index(after: $0) } ?? context.startIndex

        return (start == text.startIndex ? "" : "…") + text[start...]
    }
}

// MARK: - View Model Search

extension JournalViewModel {
    static func search(_ entries: [JournalEntry], using search: JournalSearch) -> [JournalEntry] {
        guard search.isActive else { return entries }

        return entries.filter {
            search.firstMatch(in: $0.title) != nil || search.firstMatch(in: $0.content) != nil
        }
    }
}
