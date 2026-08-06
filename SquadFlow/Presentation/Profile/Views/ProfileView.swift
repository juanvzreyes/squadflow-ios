//
//  ProfileView.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 06/08/26.
//

import SwiftUI

struct ProfileView: View {
    @Environment(AppRouter.self) private var router
    @Bindable var viewModel: ProfileViewModel

    var body: some View {
        NavigationStack {
            Group { content }
                .navigationTitle("Perfil")
                .toolbar { toolbarContent }
                .task { await viewModel.fetchProfile() }
                .sheet(isPresented: $viewModel.isShowingEditForm) {
                    ProfileFormView(viewModel: viewModel)
                }
                .alert(
                    "Error",
                    isPresented: .constant(viewModel.errorMessage != nil)
                ) {
                    Button("Aceptar") { viewModel.errorMessage = nil }
                } message: {
                    Text(viewModel.errorMessage ?? "")
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            LoadingStateView()
        } else if let profile = viewModel.profile {
            List {
                Section {
                    HStack(spacing: 14) {
                        AvatarCircleView(
                            avatarUrl: profile.avatarUrl,
                            size: 56
                        )

                        VStack(alignment: .leading, spacing: 4) {
                            Text(profile.fullName ?? "")
                                .font(.headline)
                            Text("@\(profile.username ?? "")")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 6)
                }

                Section("Detalles") {
                    LabeledContent("Usuario", value: profile.username ?? "")
                    LabeledContent("Nombre", value: profile.fullName ?? "")
                }
            }
        } else {
            ContentUnavailableView(
                "No se pudo cargar el perfil",
                systemImage: "person.crop.circle.badge.exclamationmark"
            )
        }
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                Task { await router.signOut() }
            } label: {
                Image(systemName: "rectangle.portrait.and.arrow.right")
            }
        }
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                viewModel.isShowingEditForm = true
            } label: {
                Image(systemName: "pencil")
            }
        }
    }
}
