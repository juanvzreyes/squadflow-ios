//
//  WorkspaceMembersView.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 03/08/26.
//

import SwiftUI

struct WorkspaceMembersView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: WorkspaceMembersViewModel

    @State private var searchText: String = ""

    var body: some View {
        NavigationStack {
            Form {
                inviteSection
                searchResultsSection
                membersSection
            }
            .navigationTitle("Equipo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Cerrar") { dismiss() }
                }
            }
        }
    }

    private var inviteSection: some View {
        Section {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)

                TextField("Buscar usuario...", text: $searchText)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .onChange(of: searchText) { _, newValue in
                        viewModel.updateSearch(query: newValue)
                    }

                if viewModel.isSearching {
                    ProgressView()
                        .controlSize(.small)
                }

                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                        viewModel.updateSearch(query: "")
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
            }

            if let error = viewModel.inviteErrorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(.red)
            }
        } header: {
            Text("Invitar a un compañero")
        } footer: {
            Text("Escribe al menos 2 caracteres para buscar")
        }
    }

    @ViewBuilder
    private var searchResultsSection: some View {
        if !viewModel.searchResults.isEmpty {
            Section("Resultados") {
                ForEach(viewModel.searchResults) { profile in
                    Button {
                        Task {
                            await viewModel.inviteMember(profile: profile)
                            searchText = ""
                        }
                    } label: {
                        ProfileRowView(
                            profile: profile,
                            iconName: "person.badge.plus",
                            iconColor: .blue
                        ) {
                            Text("Agregar")
                                .font(.subheadline)
                                .foregroundStyle(.blue)
                        }
                    }
                }
            }
        } else if searchText.count >= 2 && !viewModel.isSearching {
            Section("Resultados") {
                Text("No se encontraron usuarios")
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var membersSection: some View {
        Section("Miembros actuales (\(viewModel.members.count))") {
            ForEach(viewModel.members) { member in
                ProfileRowView(
                    profile: member,
                    iconName: "person.crop.circle.fill",
                    iconColor: .secondary
                ) {
                    EmptyView()
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    if member.id != viewModel.currentUserId {
                        Button(role: .destructive) {
                            Task {
                                await viewModel.removeMember(profile: member)
                            }
                        } label: {
                            Label("Eliminar", systemImage: "trash")
                        }
                    }
                }
            }
        }
        .task {
            await viewModel.loadCurrentUser()
        }
    }
}
