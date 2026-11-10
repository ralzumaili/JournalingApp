//
//  ContentView.swift
//  JournalingApp
//
//  ✦ Created by Rawa on 29/05/1448 AH.
//

import SwiftUI
import SwiftData

// MARK: - Journal Screen

struct ContentView: View {

    // MARK: - Journal State

    @Environment(\.modelContext) private var modelContext
    @Query(sort: \JournalEntry.createdAt, order: .reverse) private var entries: [JournalEntry]
    @State private var editorSession: EditorSession?
    @State private var searchText = ""
    @State private var selectedResult: SearchResult?

    // MARK: - Screen Routes

    /// Captures the original fields each time the editor opens.
    private struct EditorSession: Identifiable {
        let id = UUID()
        let entry: JournalEntry?
        let initialDraft: JournalDraft
        let createdAt: Date

        init(entry: JournalEntry? = nil) {
            self.entry = entry
            initialDraft = JournalDraft(
                title: entry?.title ?? "",
                content: entry?.content ?? ""
            )
            createdAt = entry?.createdAt ?? .now
        }
    }

    private struct SearchResult: Hashable {
        let entry: JournalEntry
        let search: JournalSearch
    }

    // MARK: - View Body

    var body: some View {
        NavigationStack {
            journalContent
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(AppTheme.Colors.background.ignoresSafeArea())
                .navigationTitle("Journal")
                .navigationBarTitleDisplayMode(.large)
                .searchable(text: $searchText, placement: .toolbar, prompt: "Search")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("New Journal", systemImage: "plus") {
                            editorSession = EditorSession()
                        }
                        .labelStyle(.iconOnly)
                    }

                    DefaultToolbarItem(kind: .search, placement: .bottomBar)
                }
                .navigationDestination(item: $selectedResult) { result in
                    JournalSearchResultView(entry: result.entry, search: result.search)
                }
        }
        .sheet(item: $editorSession) { session in
            JournalEditorView(initialDraft: session.initialDraft, createdAt: session.createdAt) { draft in
                try JournalViewModel(modelContext: modelContext)
                    .save(draft, editing: session.entry, createdAt: session.createdAt)
            }
            .presentationDragIndicator(.visible)
            .presentationBackground(AppTheme.Colors.card)
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Journal Content

    @ViewBuilder
    private var journalContent: some View {
        let search = JournalSearch(searchText)
        let visibleEntries = JournalViewModel.search(entries, using: search)

        if search.isActive && visibleEntries.isEmpty {
            ContentUnavailableView.search(text: search.term)
        } else if entries.isEmpty {
            JournalEmptyStateView()
        } else {
            List(visibleEntries) { entry in
                journalRow(for: entry, search: search)
                    .listRowInsets(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
    }

    // MARK: - Journal Row

    private func journalRow(for entry: JournalEntry, search: JournalSearch) -> some View {
        Button {
            if search.isActive {
                selectedResult = SearchResult(entry: entry, search: search)
            } else {
                editorSession = EditorSession(entry: entry)
            }
        } label: {
            JournalCardView(entry: entry, search: search)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    ContentView()
        .modelContainer(for: JournalEntry.self, inMemory: true, isAutosaveEnabled: false)
}
