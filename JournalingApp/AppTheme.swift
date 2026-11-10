////
//  AppTheme.swift
//  JournalingApp
//
//  ✦ Created by Rawa on 29/05/1448 AH.
//

import SwiftUI

// MARK: - App Theme
/// Shared colors and typography for Journali's SwiftUI views.

enum AppTheme {

    // MARK: - Colors
    /// Uses the color symbols Xcode generates from Assets.xcassets.

    enum Colors {
        static let accent = Color(.accent)
        static let textAccent = Color(.textAccent)
        static let textPrimary = Color(.textPrimary)
        static let textSecondary = Color(.textSecondary)
        static let card = Color(.card)
        static let background = Color(.background)
        static let destructive = Color(.destructive)
    }

    // MARK: - Typography
    /// Uses the SF Pro sizes and weights from the design system.

    enum Typography {

        // Headings and Titles
        static let display = Font.system(size: 42, weight: .black)
        static let largeHeading = Font.system(size: 34, weight: .bold)
        static let mediumHeading = Font.system(size: 24, weight: .bold)
        static let cardTitle = Font.system(size: 24, weight: .semibold)

        // Body Text
        static let largeBody = Font.system(size: 20, weight: .regular)
        static let mediumBody = Font.system(size: 18, weight: .regular)
        static let supportingBody = Font.system(size: 18, weight: .light)

        // Captions
        static let mediumCaption = Font.system(size: 16, weight: .regular)
        static let smallCaption = Font.system(size: 14, weight: .regular)
    }
}
