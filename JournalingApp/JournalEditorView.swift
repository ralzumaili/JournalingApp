////
//  JournalEditorView.swift
//  JournalingApp
//
//  ✦ Created by Rawa on 30/05/1448 AH.
//

import SwiftUI

// MARK: - Journal Editor

/// Keeps the draft open until saving succeeds or the user discards it.
struct JournalEditorView: View {
    let initialDraft: JournalDraft
    let createdAt: Date
    let onSave: (JournalDraft) throws -> Void

    // MARK: - Editor State

    @Environment(\.dismiss) private var dismiss
    @State private var draft: JournalDraft
    @State private var showsDiscardAlert = false
    @State private var showsSaveError = false
    @FocusState private var isTitleFocused: Bool

    // MARK: - Initialization

    init(
        initialDraft: JournalDraft,
        createdAt: Date,
        onSave: @escaping (JournalDraft) throws -> Void
    ) {
        self.initialDraft = initialDraft
        self.createdAt = createdAt
        self.onSave = onSave
        _draft = State(initialValue: initialDraft)
    }

    private var hasChanges: Bool { draft != initialDraft }

    // MARK: - View Body

    var body: some View {
        NavigationStack {
            fields
                .padding(20)
                .background(AppTheme.Colors.card.ignoresSafeArea())
                .tint(AppTheme.Colors.textAccent)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Close", systemImage: "xmark", action: close)
                            .labelStyle(.iconOnly)
                    }

                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save Journal", systemImage: "checkmark", action: save)
                            .labelStyle(.iconOnly)
                            .buttonStyle(.glassProminent)
                            .tint(AppTheme.Colors.accent)
                            .disabled(!hasChanges || !JournalViewModel.canSave(draft))
                    }
                }
        }
        .interactiveDismissDisabled(hasChanges)
        .task { isTitleFocused = true }
        .alert("Discard Changes?", isPresented: $showsDiscardAlert) {
            Button("Discard Changes", role: .destructive) { dismiss() }
            Button("Keep Editing", role: .cancel) {}
        } message: {
            Text("Are you sure you want to discard changes on this journal?")
        }
        .alert("Couldn't Save Journal", isPresented: $showsSaveError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Your draft is still open. Try saving again.")
        }
    }

    // MARK: - Journal Fields

    private var fields: some View {
        VStack(alignment: .leading, spacing: 12) {
            TextField("Title", text: $draft.title)
                .font(AppTheme.Typography.largeHeading)
                .focused($isTitleFocused)

            Text(createdAt, format: .dateTime.day(.twoDigits).month(.twoDigits).year())
                .font(AppTheme.Typography.mediumCaption)
                .foregroundStyle(AppTheme.Colors.textSecondary)

            TextEditor(text: $draft.content)
                .font(AppTheme.Typography.mediumBody)
                .accessibilityLabel("Journal content")
                .scrollContentBackground(.hidden)
                .overlay(alignment: .topLeading) {
                    if draft.content.isEmpty {
                        Text("Type your Journal...")
                            .font(AppTheme.Typography.mediumBody)
                            .foregroundStyle(AppTheme.Colors.textSecondary)
                            .padding(.top, 8)
                            .padding(.leading, 5)
                            .allowsHitTesting(false)
                            .accessibilityHidden(true)
                    }
                }
        }
        .foregroundStyle(AppTheme.Colors.textPrimary)
    }

    // MARK: - Editor Actions

    private func close() {
        if hasChanges {
            showsDiscardAlert = true
        } else {
            dismiss()
        }
    }

    private func save() {
        do {
            try onSave(draft)
            dismiss()
        } catch {
            showsSaveError = true
        }
    }
}
