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
    @Query private var entries: [JournalEntry]
    @State private var editorSession: EditorSession?
    @State private var searchText = ""
    @State private var filter: JournalFilter = .all
    @State private var sort: JournalSort = .newestFirst
    @State private var selectedResult: SearchResult?
    @State private var entryPendingDeletion: JournalEntry?
    @State private var showsWriteError = false

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
                .toolbar { journalToolbar }
                .navigationDestination(item: $selectedResult) { result in
                    JournalSearchResultView(
                        display: JournalDisplayData(
                            entry: result.entry,
                            search: result.search,
                            showsExcerpt: false
                        )
                    )
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
        .alert(
            "Delete Journal?",
            isPresented: isConfirmingDeletion,
            presenting: entryPendingDeletion
        ) { entry in
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) { delete(entry) }
        } message: { _ in
            Text("Are you sure you want to delete this journal?")
        }
        .alert("Couldn't Save Changes", isPresented: $showsWriteError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Please try again.")
        }
    }

    // MARK: - Journal Toolbar

    @ToolbarContentBuilder
    private var journalToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            Menu {
                Section("Show") {
                    Picker("Show Journals", selection: $filter) {
                        ForEach(JournalFilter.allCases, id: \.self) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                }

                Section("Sort by Entry Date") {
                    Picker("Sort by Entry Date", selection: $sort) {
                        ForEach(JournalSort.allCases, id: \.self) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                }
            } label: {
                Label("Filter Journals", systemImage: "line.3.horizontal.decrease")
            }
            .labelStyle(.iconOnly)
            .tint(filter == .bookmarked ? AppTheme.Colors.textAccent : nil)
            .accessibilityValue(filter.rawValue)

            Button("New Journal", systemImage: "plus") {
                editorSession = EditorSession()
            }
            .labelStyle(.iconOnly)
        }

        DefaultToolbarItem(kind: .search, placement: .bottomBar)
    }

    // MARK: - Journal Content

    @ViewBuilder
    private var journalContent: some View {
        let search = JournalSearch(searchText)
        let listState = JournalViewModel.listState(
            for: entries,
            matching: search,
            filter: filter,
            sort: sort
        )

        switch listState {
        case .noSearchResults(let term):
            ContentUnavailableView.search(text: term)
        case .emptyJournal:
            JournalEmptyStateView()
        case .noBookmarks:
            ContentUnavailableView(
                "No Bookmarked Journals",
                systemImage: "bookmark",
                description: Text("Bookmark a journal to find it here.")
            )
        case .entries(let entries):
            List(entries) { entry in
                journalRow(for: entry, search: search)
                    .listRowInsets(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button("Delete Journal", systemImage: "trash.fill") {
                            entryPendingDeletion = entry
                        }
                        .tint(AppTheme.Colors.destructive)
                    }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
    }

    // MARK: - Journal Row

    private func journalRow(for entry: JournalEntry, search: JournalSearch) -> some View {
        JournalCardView(
            display: JournalDisplayData(entry: entry, search: search, showsExcerpt: true),
            onOpen: {
                if search.isActive {
                    selectedResult = SearchResult(entry: entry, search: search)
                } else {
                    editorSession = EditorSession(entry: entry)
                }
            },
            onToggleBookmark: { toggleBookmark(for: entry) }
        )
    }

    // MARK: - Bookmark Action

    private func toggleBookmark(for entry: JournalEntry) {
        do {
            try JournalViewModel(modelContext: modelContext).toggleBookmark(for: entry)
        } catch {
            showsWriteError = true
        }
    }

    // MARK: - Delete Confirmation

    /// Presents the alert while a journal is selected for deletion.
    private var isConfirmingDeletion: Binding<Bool> {
        Binding(
            get: { entryPendingDeletion != nil },
            set: { isPresented in
                if !isPresented {
                    entryPendingDeletion = nil
                }
            }
        )
    }

    private func delete(_ entry: JournalEntry) {
        do {
            try JournalViewModel(modelContext: modelContext).delete(entry)
        } catch {
            showsWriteError = true
        }
    }
}

// MARK: - Preview

#Preview {
    ContentView()
        .modelContainer(for: JournalEntry.self, inMemory: true, isAutosaveEnabled: false)
}
