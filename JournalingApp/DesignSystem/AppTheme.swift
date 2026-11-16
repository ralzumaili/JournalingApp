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
    /// Uses the color symbols generated from Assets.xcassets.
    
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
    /// Uses system text styles that follow the user's Dynamic Type setting.

    enum Typography {
        static let display = Font.largeTitle.weight(.black)
        static let largeHeading = Font.largeTitle.bold()
        static let mediumHeading = Font.title2.bold()
        static let cardTitle = Font.title2.weight(.semibold)
        static let mediumBody = Font.body
        static let supportingBody = Font.body.weight(.light)
        static let mediumCaption = Font.callout
        static let smallCaption = Font.footnote
    }
}
