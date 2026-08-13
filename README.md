# SquadFlow

SquadFlow is a collaborative task management app for iOS designed for teams. It lets you create workspaces, organize tasks with list and Kanban views, invite members, and manage your team — all in real time. Built entirely with Apple's native technologies and powered by Supabase and Google Cloud on the backend.

## Key Features

* **Workspaces:** Create and manage shared workspaces to organize your team's projects.
* **Task Management:** Create, edit, assign, and delete tasks within a workspace. Track progress across four statuses: *To Do*, *In Progress*, *Review*, and *Done*.
* **Kanban Board:** Visualize your workflow with a drag-and-drop Kanban board, in addition to a classic list view.
* **Real-Time Updates:** Tasks sync instantly across all team members using Supabase Realtime channels.
* **Team Collaboration:** Invite members to your workspaces and manage roles and permissions.
* **Authentication:** Secure sign-up and sign-in with email/password, or sign in seamlessly with your Google account.
* **User Profiles:** Customize your profile with a username, full name, and avatar photo.
* **Modern UI:** Built with SwiftUI for a smooth, responsive, and fully native user experience.

## Technologies Used

| Category | Technology |
|---|---|
| **UI** | SwiftUI |
| **Architecture** | Clean Architecture / MVVM |
| **Language** | Swift 6.0 |
| **Platform** | iOS (Native) |
| **Backend** | [Supabase](https://supabase.com) (Auth, Database, Storage, Realtime) |
| **Authentication** | Supabase Auth + [Google Sign-In for iOS](https://developers.google.com/identity/sign-in/ios) |
| **Dependency Management** | Swift Package Manager (SPM) |

## Backend Services

### Supabase

SquadFlow uses [Supabase](https://supabase.com) as its Backend-as-a-Service (BaaS), providing the following services:

* **Authentication:** Email/password sign-up and sign-in, integrated with Google OAuth via ID token exchange.
* **Database (PostgreSQL):** Stores all application data including workspaces, tasks, profiles, and workspace memberships.
* **Realtime:** Powers live task synchronization across devices using Supabase Realtime channels, delivering insert, update, and delete events instantly.
* **Storage:** Handles user avatar uploads and retrieval through Supabase Storage buckets.

The app connects to Supabase through the official [`supabase-swift`](https://github.com/supabase/supabase-swift) SDK, managed as a singleton via `SupabaseManager`.

### Google Cloud

SquadFlow leverages Google Cloud for social authentication:

* **Google Sign-In (Client):** Uses the [`GoogleSignIn-iOS`](https://github.com/google/GoogleSignIn-iOS) SDK to present the native Google sign-in flow on the device. The client is configured with a **Google Client ID** registered in the Google Cloud Console, along with a custom URL scheme in `Info.plist` for handling the OAuth redirect.

* **Google Sign-In (Server):** A **Server Client ID** (also known as the Web Client ID) is used to obtain an ID token from Google that is then exchanged with Supabase Auth using `signInWithIdToken`. This allows Supabase to verify the identity server-side and create or link the user session securely.

Both client IDs are managed through the Google Cloud Console under **APIs & Services > Credentials** and stored locally in the `Secrets.swift` file (excluded from version control via `.gitignore`).

## Project Structure

The codebase follows Clean Architecture principles, separating concerns into clearly defined layers:

```
SquadFlow/
├── App/                          # Application entry point and configuration
│   ├── SquadFlowApp.swift        # @main entry point
│   ├── RootView.swift            # Root view with auth state routing
│   ├── DependencyContainer.swift # Dependency injection container
│   ├── Secrets.swift             # API keys and secrets (git-ignored)
│   └── Secrets.swift.template    # Template for required secrets
│
├── Domain/                       # Business logic layer (framework-independent)
│   ├── Models/                   # Domain entities (TaskItem, Workspace, Profile)
│   ├── UseCases/                 # Application use cases organized by feature
│   │   ├── Auth/                 # SignIn, SignUp, SignInWithGoogle
│   │   ├── Tasks/                # CRUD operations and real-time observation
│   │   ├── Workspaces/           # Workspace management and member invitations
│   │   └── Profile/              # Profile fetching and updating
│   ├── RepositoryProtocols/      # Abstract repository interfaces (ports)
│   ├── Validators/               # Input validation and domain error types
│   └── Mappers/                  # Domain-to-presentation data transformers
│
├── Data/                         # Data access layer (infrastructure)
│   ├── Network/                  # SupabaseManager (singleton client)
│   ├── Repositories/             # Concrete repository implementations
│   └── DTOs/                     # Data Transfer Objects for API communication
│
├── Presentation/                 # UI layer organized by feature module
│   ├── Authentication/           # Auth views and view models
│   ├── Workspaces/               # Workspace list, form, and members management
│   ├── Tasks/                    # Task list, Kanban board, and task form
│   ├── Profile/                  # Profile view, form, and avatar picker
│   └── Routing/                  # AppRouter for navigation and auth state
│
├── Shared/                       # Shared utilities across features
│   ├── Components/               # Reusable UI components (avatars, badges, states)
│   └── Mocks/                    # Mock repositories for previews and testing
│
└── Resources/                    # Design assets (colors, images)
    └── Assets.xcassets
```

## Getting Started

### Prerequisites

* **macOS** with [Xcode](https://developer.apple.com/xcode/) 16.0 or later installed.
* An **Apple Developer account** (for running on a physical device).
* A [**Supabase**](https://supabase.com) project with Auth, Database, and Storage configured.
* A [**Google Cloud**](https://console.cloud.google.com) project with the Google Sign-In API enabled and OAuth 2.0 credentials created (iOS client ID and Web client ID).

### Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/juanvzreyes/SquadFlow.git
   cd SquadFlow
   ```

2. **Configure secrets:**
   ```bash
   cp SquadFlow/App/Secrets.swift.template SquadFlow/App/Secrets.swift
   ```
   Open `Secrets.swift` and fill in your values:
   ```swift
   enum Secrets {
       static let supabaseURL = "YOUR_SUPABASE_URL"
       static let supabaseKey = "YOUR_SUPABASE_KEY"
       static let googleClientID = "YOUR_GOOGLE_CLIENT_ID"
       static let googleServerClientID = "YOUR_GOOGLE_SERVER_CLIENT_ID"
   }
   ```

3. **Open in Xcode:**
   ```bash
   open SquadFlow.xcodeproj
   ```
   Xcode will automatically resolve the Swift Package Manager dependencies (`supabase-swift` and `GoogleSignIn-iOS`).

4. **Update the URL scheme:**
   In Xcode, go to your target's **Info** tab and verify that the URL scheme under **URL Types** matches your Google Client ID (reversed), e.g.:
   ```
   com.googleusercontent.apps.YOUR_CLIENT_ID
   ```

5. **Build and run** on a simulator or device running iOS 26.5 or later.

## System Requirements

| Requirement | Version |
|---|---|
| **iOS** | 26.5 or later |
| **Xcode** | 16.0 or later |
| **Swift** | 6.0 |

## Dependencies

| Package | Purpose |
|---|---|
| [`supabase-swift`](https://github.com/supabase/supabase-swift) | Supabase client SDK for Auth, Database, Realtime, and Storage |
| [`GoogleSignIn-iOS`](https://github.com/google/GoogleSignIn-iOS) | Google Sign-In SDK for native OAuth authentication |

## Author

* [@juanvzreyes](https://github.com/juanvzreyes) — Creator and Developer.
