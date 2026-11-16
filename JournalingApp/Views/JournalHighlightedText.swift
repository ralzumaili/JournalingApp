////
//  JournalHighlightedText.swift
//  JournalingApp
//
//  ✦ Created by Rawa on 30/05/1448 AH.
//

import SwiftUI

// MARK: - Highlighted Text

struct JournalHighlightedText: View {
    let display: JournalDisplayData.HighlightedText

    var body: some View {
        Text(highlightedText)
    }

    // MARK: - Highlight Appearance

    private var highlightedText: AttributedString {
        var result = AttributedString(display.text)

        // نستخدم مواضع التطابق الجاهزة ونطبّق عليها ألوان الثيم.
        for match in display.matches {
            guard let range = Range(match, in: result) else { continue }
            result[range].backgroundColor = AppTheme.Colors.textAccent
            result[range].foregroundColor = AppTheme.Colors.background
        }

        return result
    }
}
