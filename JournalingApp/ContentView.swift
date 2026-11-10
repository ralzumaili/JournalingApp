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
    @State private var showsNewJournal = false
    @State private var searchText = ""
    @State private var selectedResult: SearchResult?

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
                            showsNewJournal = true
                        }
                        .labelStyle(.iconOnly)
                    }

                    DefaultToolbarItem(kind: .search, placement: .bottomBar)
                }
                .navigationDestination(item: $selectedResult) { result in
                    JournalSearchResultView(entry: result.entry, search: result.search)
                }
                .sheet(isPresented: $showsNewJournal) {
                    JournalEditorView { draft, date in
                        try JournalViewModel(modelContext: modelContext)
                            .add(draft, createdAt: date)
                    }
                    .presentationDragIndicator(.visible)
                    .presentationBackground(AppTheme.Colors.card)
                }
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

    @ViewBuilder
    private func journalRow(for entry: JournalEntry, search: JournalSearch) -> some View {
        if search.isActive {
            Button {
                selectedResult = SearchResult(entry: entry, search: search)
            } label: {
                JournalCardView(entry: entry, search: search)
            }
            .buttonStyle(.plain)
        } else {
            JournalCardView(entry: entry)
        }
    }
}

// MARK: - Preview

#Preview {
    ContentView()
        .modelContainer(for: JournalEntry.self, inMemory: true, isAutosaveEnabled: false)
}
