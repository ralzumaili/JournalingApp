//
//  JournaliApp.swift
//  JournalingApp
//
//  ✦ Created by Rawa on 29/05/1448 AH.
//


// MARK: - Imports

import SwiftUI
import SwiftData

// MARK: - App Entry Point

@main
struct JournalingAppApp: App {

    // MARK: - Splash Configuration

    private static let splashDuration: Duration = .seconds(3)
    @State private var isShowingSplash = true

    // MARK: - App Scene

    var body: some Scene {
        WindowGroup {
            if isShowingSplash {
                SplashView()
                    .task {
                        await showJournalAfterSplash()
                    }
            } else {
                ContentView()
            }
        }
        .modelContainer(for: JournalEntry.self, isAutosaveEnabled: false)
    }

    // MARK: - Startup Transition

    private func showJournalAfterSplash() async {
        do {
            try await Task.sleep(for: Self.splashDuration)
            isShowingSplash = false
        } catch {
            // Keep the current screen if SwiftUI cancels the splash task.
        }
    }
}
