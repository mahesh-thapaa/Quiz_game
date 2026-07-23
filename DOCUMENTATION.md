# Football Quiz Game — Project Documentation

**Platform:** Flutter (Android / iOS)
**Backend:** Firebase (Firestore, Auth, Storage, Messaging, Crashlytics)
**Version:** 1.0.0+1
**Language:** Dart (SDK ^3.11.1)
**Font:** Inter (Variable)

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Architecture & Folder Structure](#2-architecture--folder-structure)
3. [Dependencies](#3-dependencies)
4. [App Theme & Design System](#4-app-theme--design-system)
5. [Authentication](#5-authentication)
6. [Quiz System](#6-quiz-system)
7. [Level & Progress System](#7-level--progress-system)
8. [Streak System](#8-streak-system)
9. [Leaderboard](#9-leaderboard)
10. [Ad Integration](#10-ad-integration)
11. [Notifications](#11-notifications)
12. [Screens & Navigation](#12-screens--navigation)
13. [Data Layer](#13-data-layer)
14. [Firebase Firestore Structure](#14-firebase-firestore-structure)
15. [Assets](#15-assets)

---

## 1. Project Overview

**Football Quiz Game** is a gamified mobile quiz application built with Flutter, targeting football (soccer) enthusiasts. Players answer trivia questions across multiple categories — players, stadiums, club logos, jerseys, legends, and more — to earn coins, XP, and stars, climb a global leaderboard, and maintain a daily login streak.

### Key Features

- **Multiple quiz categories** — Player Quiz, Stadium Quiz, Jersey Quiz, Logo Master, Club Quiz, Legend Quiz, Manager Quiz, National Quiz, Transfer Quiz
- **Discover section** — locked premium categories unlocked via Stars or Coins (Ballon d'Or Quiz, World Cup, Goalkeeper Legends, Golden Boot, Derby Rivalries, Tactics Quiz, Top Assists Quiz, Historic Finals)
- **Quick Quiz** — dynamically assembled mix of questions from all unlocked categories
- **Level grid** — 48-level progression grid per category with bonus levels every 6th slot
- **Coin & XP economy** — earn rewards on level completion, daily bonus, and streak completion
- **7-day login streak** — rewards 500 coins on full cycle completion
- **Global leaderboard** — real-time XP-ranked board (top 500 players), excludes guests
- **Guest mode** — play without an account; progress migrates on sign-up
- **Firebase Auth** — email/password sign-up, email verification, anonymous guest login, password reset
- **Google AdMob** — banner ads and interstitial ads with debug/production switching
- **Push notifications** — Firebase Cloud Messaging (FCM) for background and foreground messages
- **Local notifications** — flutter_local_notifications for scheduled reminders
- **Crash reporting** — Firebase Crashlytics
- **Theme support** — light and dark mode with a persistent ThemeProvider
- **Internet connectivity monitoring** — graceful offline handling via connectivity_plus
- **Profile management** — avatar upload (Cloudinary), username, bio editing

---

## 2. Architecture & Folder Structure

The project follows a **Provider-based state management** pattern with a clear separation of concerns across controllers, providers, models, services, screens, and data layers.

```
quiz_game/
├── lib/
│   ├── main.dart                    # App entry point, Firebase init, providers
│   ├── api_keys.dart                # Cloudinary base URL and API constants
│   ├── firebase_options.dart        # Auto-generated Firebase config
│   ├── controllers/                 # Business logic (no UI)
│   │   ├── auth_controller.dart
│   │   ├── quiz_controller.dart
│   │   ├── streak_controller.dart
│   │   ├── level_grid_controller.dart
│   │   ├── level_progress_services.dart
│   │   ├── ad_display_controller.dart
│   │   ├── notification_controller.dart
│   │   ├── fcm_notification_controller.dart
│   │   ├── profile_image_controller.dart
│   │   ├── password_controller.dart
│   │   ├── daily_challenger_controller.dart
│   │   └── star_calculation_service.dart
│   ├── provider/                    # ChangeNotifier providers (state)
│   │   ├── user_progress_provider.dart
│   │   ├── leaderboard_provider.dart
│   │   ├── theme_provider.dart
│   │   ├── profile_image_provider.dart
│   │   ├── password_provider.dart
│   │   ├── notification_provider.dart
│   │   └── daily_challenger_provider.dart
│   ├── models/                      # Data models / entities
│   │   ├── colors.dart
│   │   ├── quiz_models/
│   │   ├── home_models/
│   │   ├── profile/
│   │   ├── discover/
│   │   ├── login_models/
│   │   └── (other model files)
│   ├── data/                        # Static data / seed data
│   │   ├── home_data.dart
│   │   └── discover_data.dart
│   ├── services/                    # Platform/infrastructure services
│   │   ├── ads/ad_service.dart
│   │   └── internet/internet_service.dart
│   ├── auth/                        # Auth screens
│   │   ├── email_login.dart
│   │   ├── email_signup.dart
│   │   ├── email_verification_screen.dart
│   │   └── change_password_screen.dart
│   ├── screens/                     # UI screens
│   │   ├── splash_screen/
│   │   ├── main_screen/
│   │   ├── home/
│   │   ├── Quiz_screen/
│   │   ├── common/                  # Level grid + gameplay
│   │   ├── discover_screen/
│   │   ├── profile/
│   │   ├── streak/
│   │   ├── bonus/
│   │   ├── buttons/
│   │   └── login.dart
│   └── painters/
│       └── confetti_painter.dart
├── assets/
│   ├── images/                      # Category thumbnails, player photos
│   ├── fonts/                       # Inter variable font
│   └── svg/                         # football.svg, coin.svg, gift.svg, etc.
├── android/
├── ios/
├── pubspec.yaml
└── firestore.rules
```

### State Management Pattern

All global state is managed via `ChangeNotifier` providers registered in `MultiProvider` at the root (`AppRoot`). Controllers handle business logic and Firestore interactions; providers expose reactive state to the UI.

```
AppRoot (MultiProvider)
 ├── ThemeProvider
 ├── UserProgressProvider
 ├── LeaderboardProvider
 ├── AuthController
 ├── ProfileImageProvider
 ├── PasswordProvider
 ├── DailyChallengerProvider
 ├── NotificationProvider
 └── InternetService
```

---

## 3. Dependencies

| Package | Version | Purpose |
|---|---|---|
| `flutter` | SDK | UI framework |
| `provider` | ^6.1.5+1 | State management |
| `firebase_core` | ^4.12.1 | Firebase initialization |
| `firebase_auth` | ^6.5.6 | Authentication |
| `cloud_firestore` | ^6.7.1 | Database |
| `firebase_storage` | ^13.4.5 | File storage |
| `firebase_database` | ^12.4.6 | Realtime database |
| `firebase_messaging` | ^16.4.3 | Push notifications (FCM) |
| `firebase_crashlytics` | ^5.2.6 | Crash reporting |
| `google_mobile_ads` | ^9.0.0 | AdMob banner & interstitial ads |
| `flutter_local_notifications` | ^22.1.0 | Local scheduled notifications |
| `connectivity_plus` | ^7.3.0 | Internet connectivity monitoring |
| `cached_network_image` | ^3.4.1 | Network image caching |
| `image_picker` | ^1.2.1 | Camera / gallery image selection |
| `cloudinary_public` | ^0.23.1 | Profile image uploads |
| `http` | ^1.1.0 | HTTP requests |
| `shared_preferences` | ^2.2.2 | Local key-value persistence |
| `timezone` | ^0.11.1 | Timezone-aware date handling (Asia/Kathmandu) |
| `confetti` | ^0.8.0 | Confetti animation on level complete |
| `flutter_svg` | ^2.2.4 | SVG asset rendering |
| `image` | ^4.2.0 | Image processing |
| `path_provider` | ^2.1.2 | File system paths |
| `flutter_launcher_icons` | ^0.14.4 | App icon generation |

---

## 4. App Theme & Design System

### Color Palette

The app uses a dark-first design with green as the primary accent.

| Token | Hex | Usage |
|---|---|---|
| `background` | `#0B141E` | Main screen background |
| `cardBg` | `#112233` | Card backgrounds |
| `deepCard` | `#0F1E2D` | Navigation bar, deep cards |
| `primary` | `#19B357` | Primary actions, titles |
| `secondary` | `#059669` | Gradient end, secondary actions |
| `hText` | `#FFFFFF` | Primary text (dark mode) |
| `stext` | `#94A3B8` | Secondary / subtitle text |
| `divider` | `#1E2D3D` | Dividers, borders |
| `doller` | `#FFD700` | Coin icon, gold highlights |
| `dShade` | `#E6A817` | Warning / highlight shade |

### Light Mode Overrides

| Token | Hex |
|---|---|
| `background` | `#F1F5F9` |
| `cardBg` | `#FFFFFF` |
| `hText` | `#0F172A` |
| `stext` | `#64748B` |
| `divider` | `#E2E8F0` |

### Gradients

```dart
// Primary gradient (buttons, accents)
LinearGradient: #19B357 → #059669 (top-left to bottom-right)

// Icon box gradient
LinearGradient: #22C55E → #059669 (top-left to bottom-right)
```

### Typography

- **Font Family:** Inter (Variable font — supports weight and optical size axes)
- **Italic variant:** Inter Italic Variable Font
- Applied globally via `ThemeData(fontFamily: 'Inter')`

### ThemeColors Helper

`ThemeColors.of(context)` returns the correct color set based on the current brightness, allowing all screens to adapt to light/dark mode without manual `Theme.of(context).brightness` checks.

---

## 5. Authentication

**File:** `lib/controllers/auth_controller.dart`
**Provider:** `AuthController extends ChangeNotifier`

### Auth Flows

#### Email / Password Sign-In
1. Calls `FirebaseAuth.signInWithEmailAndPassword`
2. Reloads user to get fresh email verification status
3. Blocks login if email is not verified — shows friendly error
4. Returns `bool` success

#### Anonymous Guest Login
1. Calls `FirebaseAuth.signInAnonymously`
2. Creates a Firestore user document (`users/{uid}`) if not exists with default values: `Coin: 0, XP: 0, Stars: 0, isGuest: true`
3. Allows full gameplay without registration

#### Email Sign-Up
1. Checks username uniqueness in `usernames` collection
2. If user was a guest → **links** the anonymous account with email credentials (preserves progress)
3. If fresh user → creates new Firebase Auth account
4. Creates/updates `users/{uid}` document
5. Reserves username in `usernames/{username}` collection
6. Calls `StreakController.onLogin()` to initialize streak
7. Sends email verification

#### Guest-to-Registered Migration
When a guest signs up, `UserProgressProvider.migrateGuestData()` copies:
- The `users/{guestUid}` document to `users/{newUid}`
- All `user_progress/{guestUid}/categories/*/levels/*` subcollections to the new UID

#### Password Reset
Sends a Firebase password reset email. Validates that the email field is non-empty and contains `@` before calling Firebase.

### Error Handling

All Firebase error codes are mapped to user-friendly messages:

| Firebase Code | Shown Message |
|---|---|
| `user-not-found`, `wrong-password`, `invalid-credential` | "Incorrect email or password" |
| `invalid-email` | "Please enter a valid email address." |
| `too-many-requests` | "Too many attempts. Please try again later." |
| `network-request-failed` | "No internet connection." |
| `email-already-in-use` | "An account with this email already exists." |
| `weak-password` | "Password must be at least 6 characters." |

---

## 6. Quiz System

### QuizController

**File:** `lib/controllers/quiz_controller.dart`
**Type:** Static utility class (no state)

#### `loadQuizData()`
Loads quiz metadata and level progress for a standard category:
1. Loads level progress from `LevelProgressService`
2. Queries `quizzes` collection by `category` name
3. Fetches the `levels` subcollection, extracts level numbers
4. Separates **bonus levels** (every 6th slot) from regular levels
5. Returns: `progress`, `levelDocIds` (Map<int, String>), `bonusSlotToDocId`, `quizDocReference`

#### `fetchQuestionsForLevelId()`
On-demand question fetch for a single level — queries `quizzes/{id}/levels/{levelId}/questions`.

#### `loadQuickQuizData()`
Dynamically assembles the Quick Quiz from ALL unlocked categories:

| Condition | Category Added |
|---|---|
| Always | Player Quiz, Stadium Quiz, Jersey Quiz, Logo Master |
| Level ≥ 5 | Legend Quiz |
| Coins ≥ 1,000 | National Quiz |
| Level ≥ 7 | Manager Quiz |
| Coins ≥ 5,000 | Transfer Quiz |
| Level ≥ 9 | Ballon d'Or Quiz |
| Coins ≥ 10,000 | World Cup |
| Level ≥ 11 | Goalkeeper Legends |
| Coins ≥ 20,000 | Golden Boot |

Uses **parallel Firestore reads** (`Future.wait`) to avoid N+1 sequential queries. Questions are shuffled and distributed into 48 level slots (10 questions each). Bonus levels occur at every 6th position.

#### Level Naming
- Regular: `LEVEL {n}`
- Bonus: `BONUS LEVEL {n ÷ 6}` (triggered when `gridPos % 6 == 0`)

### Quiz Categories

#### Standard Categories (Home Screen)
| Category | Firestore Name | Description |
|---|---|---|
| Player Quiz | `Player Quiz` | Identify football players |
| Stadium Quiz | `Stadium Quiz` | Identify famous stadiums |
| Jersey Quiz | `Jersey Quiz` | Guess the team from jersey |
| Logo Master | `Logo Master` | Guess club from crest |
| Club Quiz | `Club Quiz` | Club-related trivia |
| Legend Quiz | `Legend Quiz` | Legendary players (Level ≥ 5) |
| National Quiz | `National Quiz` | National team trivia |
| Manager Quiz | `Manager Quiz` | Famous managers (Level ≥ 7) |
| Transfer Quiz | `Transfer Quiz` | Transfer history trivia |

#### Discover / Premium Categories
| Category | Unlock Condition |
|---|---|
| Ballon d'Or Quiz | 220 Stars |
| World Cup | 35,000 Coins |
| Goalkeeper Legends | 250 Stars |
| Golden Boot | 450,000 Coins |
| Derby Rivalries | Coming Soon |
| Tactics Quiz | Coming Soon |
| Top Assists Quiz | Coming Soon |
| Historic Finals | Coming Soon |

### LevelGridScreen

**File:** `lib/screens/common/level_grid_screen.dart`

Displays a 48-slot grid of level tiles for any category. Each tile shows:
- Level number / BONUS label
- Completion stars (0–3)
- Lock/unlock state

On tap: shows a bottom sheet preview (`quiz_sheets.dart`), then launches `QuizGameplayScreen` with the fetched questions.

---

## 7. Level & Progress System

**File:** `lib/provider/user_progress_provider.dart`
**Provider:** `UserProgressProvider extends ChangeNotifier`

### User Stats (Firestore: `users/{uid}`)

| Field | Type | Description |
|---|---|---|
| `Coin` | int | In-game currency |
| `XP` | int | Experience points |
| `Stars` | int | Cumulative stars earned |
| `CompletedSections` | int | Number of completed sections (0–4) |
| `QuizLevelsInSection` | int | Levels completed in current section (0–48) |
| `unlockedCategories` | List | Categories unlocked with coins |
| `username` | String | Display name |
| `bio` | String | User bio |
| `isGuest` | bool | Guest flag |

### Level Calculation

```
level = completedSections + 1        (range: 1–5)
xpProgress = quizLevelsInSection / 48
```

- Each section = **48 quiz levels**
- Total sections = **4** (level cap = 5)
- Completing 48 levels in a section → increments `completedSections`, resets `quizLevelsInSection`

### `onQuizLevelCompleted()`
Called after each level:
- Adds `customCoins`, `customXP`, `earnedStars` to totals
- Increments `quizLevelsInSection` only if `earnedStars > 0` (prevents spamming with 0-star completions)
- Checks for section completion → level up
- Syncs to Firestore

### Category Unlocking

Two unlock types:
- **Stars-based:** `_stars >= unlockValue` (checked locally, no purchase needed)
- **Coins-based:** Deducts coins, adds `categoryId` to `unlockedCategories`, syncs to Firestore

### `clearAndReload()`
Called on HomeScreen init — wipes all in-memory state then re-fetches from Firestore. Prevents the previous user's data from leaking to the next user after logout.

---

## 8. Streak System

**File:** `lib/controllers/streak_controller.dart`
**Model:** `StreakModel` (`lib/models/home_models/streak_model.dart`)
**Timezone:** Asia/Kathmandu (Nepal Standard Time, UTC+5:45)

### 7-Day Streak Logic

The streak resets to day 1 if a login day is missed. The Firestore document is stored in `streaks/{uid}`.

#### `onLogin()` — Login Day Evaluation

| Scenario | Result |
|---|---|
| First login ever | `currentDay = 1`, `rewardClaimed = false` |
| Already logged in today | No change (idempotent) |
| Consecutive day (yesterday logged) | `currentDay++` |
| Consecutive day and reached day 7 | `justCompleted = true`, `rewardClaimed = false` |
| Cycle just finished (day ≥ 7 yesterday) | Reset to `currentDay = 1` for new cycle |
| Missed one or more days | Reset to `currentDay = 1` |

#### `claimReward()`
Sets `rewardClaimed = true` in Firestore.

#### `resetAfterCompletion()`
Called from `UserProgressProvider.onStreakCompleted()`. Keeps `currentDay = 7` in Firestore so the UI doesn't briefly show 0/7 — the next login naturally starts day 1.

#### Streak Completion Reward
- **500 coins** credited via `UserProgressProvider.onStreakCompleted()`

### StreakModel Fields

| Field | Type | Description |
|---|---|---|
| `currentDay` | int | Current streak day (0–7) |
| `totalDays` | int | Total days per cycle (7) |
| `rewardClaimed` | bool | Whether the reward was claimed |
| `justCompleted` | bool | True on the exact login that completes the cycle |

---

## 9. Leaderboard

**File:** `lib/provider/leaderboard_provider.dart`
**Provider:** `LeaderboardProvider extends ChangeNotifier`

### Features
- **Real-time streaming** via `listenLeaderboard()` — uses Firestore `snapshots()` stream
- **One-time fetch** via `load()` — used for initial load
- Sorted by **XP descending**, then **username alphabetically** on XP tie
- **Excludes guest users** (`isGuest == true`)
- Limited to **500 users** to prevent unbounded memory/bandwidth growth

### Computed Properties

| Property | Description |
|---|---|
| `top3` | Top 3 entries; if current user is in top 3, shows them. Otherwise excludes current user from top 3 |
| `top4` | Same logic for top 4 |
| `currentUser` | The logged-in user's leaderboard entry |
| `currentUserRank` | User's rank (defaults to `allUsers.length + 1` if not found) |

### LeaderboardEntry Model

| Field | Source |
|---|---|
| `username` | `users/{uid}.username` |
| `xpPoints` | `users/{uid}.XP` |
| `coins` | `users/{uid}.Coin` |
| `bio` | `users/{uid}.bio` |
| `avatarUrl` | `users/{uid}.avatarUrl` |
| `rank` | Assigned after sort |
| `isCurrentUser` | `doc.id == currentUid` |

---

## 10. Ad Integration

**File:** `lib/services/ads/ad_service.dart`
**Package:** `google_mobile_ads ^9.0.0`
**Pattern:** Singleton (`AdService._internal()`)

### Ad Units

| Type | Debug ID | Production ID |
|---|---|---|
| Banner | `ca-app-pub-3940256099942544/6300978111` | `ca-app-pub-2829352214511086/1997866154` |
| Interstitial | `ca-app-pub-3940256099942544/1033173712` | `ca-app-pub-2829352214511086/9555276602` |

Debug/production switching is automatic via `kDebugMode`. Ad unit IDs can also be overridden at build time via `--dart-define`:
```
--dart-define=ADMOB_BANNER_UNIT_ID=ca-app-pub-xxx
--dart-define=ADMOB_INTERSTITIAL_UNIT_ID=ca-app-pub-xxx
```

### Interstitial Ad Flow
1. `init()` → `loadInterstitialAd()` called at app startup
2. Ad loads in background; retries up to 5 times with exponential backoff (`retryAttempt * 5` seconds)
3. `showInterstitialAd()` — shows if ready; otherwise triggers a reload and calls `onAdFailedToShow`
4. After dismissal: disposes old ad, preloads next one

### Banner Ad Flow
- `preloadBannerAd()` caches a banner at init
- `createBannerAd()` returns the cached banner (if available) or creates a new one
- Each banner widget manages its own lifecycle

### AdDisplayController
**File:** `lib/controllers/ad_display_controller.dart`
Handles the logic for deciding when to show interstitial ads (e.g., after level completion).

---

## 11. Notifications

### Firebase Cloud Messaging (FCM)
**File:** `lib/controllers/fcm_notification_controller.dart`

- Background message handler registered via `FirebaseMessaging.onBackgroundMessage`
- Handler is annotated `@pragma('vm:entry-point')` for AOT compilation compatibility
- Re-initializes Firebase inside the background isolate

### Local Notifications
**File:** `lib/controllers/notification_controller.dart`
**Package:** `flutter_local_notifications ^22.1.0`

- Initialized at app startup via `NotificationController().init()`
- Used for scheduled reminders (e.g., daily streak reminders)
- Timezone support via the `timezone` package (Asia/Kathmandu)

### NotificationProvider
**File:** `lib/provider/notification_provider.dart`
Manages notification state and permission requests. Automatically handles notification setup in the `HomeScreen` lifecycle.

---

## 12. Screens & Navigation

### Navigation Structure

```
SplashScreen
  └── (Auth check)
       ├── LoginScreen  →  EmailLoginScreen / EmailSignupScreen
       │                    └── EmailVerificationScreen
       └── MainScreen (Bottom Nav)
            ├── [0] HomeScreen
            ├── [1] QuizScreen
            ├── [2] LeaderboardScreen
            └── [3] ProfileScreen
                  ├── EditProfileScreen
                  ├── SettingsScreen
                  └── ChangePasswordScreen
```

### Screen Descriptions

| Screen | File | Description |
|---|---|---|
| `SplashScreen` | `screens/splash_screen/splash_screen.dart` | Firebase auth check, animated intro |
| `LoginScreen` | `screens/login.dart` | Entry point with guest/email login options |
| `EmailLoginScreen` | `auth/email_login.dart` | Email + password login form |
| `EmailSignupScreen` | `auth/email_signup.dart` | Registration form with username check |
| `EmailVerificationScreen` | `auth/email_verification_screen.dart` | Resend/poll verification status |
| `ChangePasswordScreen` | `auth/change_password_screen.dart` | Update password in-app |
| `MainScreen` | `screens/main_screen/main_screen.dart` | Bottom navigation shell |
| `HomeScreen` | `screens/home/home_screen.dart` | Dashboard: bonus, quick play, categories, streak |
| `QuizScreen` | `screens/Quiz_screen/quiz_screen.dart` | Category grid + Discover button |
| `LevelGridScreen` | `screens/common/level_grid_screen.dart` | 48-level grid for any category |
| `QuizGameplayScreen` | `screens/common/gameplay/` | Active quiz gameplay |
| `DiscoverScreen` | `screens/discover_screen/discover_screen.dart` | Premium/locked categories |
| `ProfileScreen` | `screens/profile/profile_screen/` | User stats, avatar, bio |
| `StreakScreen` | `screens/streak/` | Streak visualization |
| `ClaimRewardDialog` | `screens/bonus/claim_reward_dialog.dart` | Daily bonus / streak reward dialog |

### HomeScreen Sections
1. **HomeAppBar** — profile avatar, level indicator, coin balance
2. **DailyBonusCard** — 50 coins daily free bonus
3. **QuickPlayCard** — one-tap Quick Quiz launcher
4. **Recommended Grid** — Player Challenge, Logo Master (2-column)
5. **StreakCard** — 7-day streak progress display
6. **Popular Categories** — Player Quiz, Stadium Quiz, Club Quiz (3-column row)

---

## 13. Data Layer

### Static Data

#### `HomeData` (`lib/data/home_data.dart`)
Defines static constants for:
- `DailyBonusModel` — 50 coins, shown on HomeScreen
- `recommendedQuizzes` — Player Challenge, Logo Master
- `categories` — Player Quiz, Stadium Quiz, Club Quiz

#### `DiscoverData` (`lib/data/discover_data.dart`)
Returns a list of `DiscoverModels` with 8 premium categories. Each entry contains:
- `id`, `title`, `categoryId`, `firestoreName`
- `imageUrl` (Cloudinary CDN thumbnail)
- `unlockType` — `UnlockType.level`, `UnlockType.coins`, or `UnlockType.comingSoon`
- `unlockValue`, `unlockText`, `snackbarMessage`

### Models

| Model | Location | Description |
|---|---|---|
| `QuizModel` | `models/quiz_models/quiz_models_file.dart` | Quiz card data |
| `QuizLevel` | `models/quiz_models/quiz_level.dart` | Level with questions |
| `QuizQuestion` | `models/quiz_models/quiz_level.dart` | Single question + options |
| `QuizLevelTile` | `models/quiz_level_tile.dart` | Grid tile state |
| `StreakModel` | `models/home_models/streak_model.dart` | Streak state |
| `LeaderboardEntry` | `models/profile/leaderboard_entry_models.dart` | Ranked user entry |
| `DiscoverModels` | `models/discover/discover_models.dart` | Discover section card |
| `CategoryModel` | `models/home_models/home_models.dart` | Home category card |
| `QuizCardModel` | `models/home_models/home_models.dart` | Recommended quiz card |
| `DailyBonusModel` | `models/home_models/home_models.dart` | Daily bonus data |
| `LevelResultModels` | `models/level_result_models.dart` | Post-level result data |
| `LevelOverviewModel` | `models/level_overview_model.dart` | Level preview data |
| `ConfettiParticle` | `models/confetti_particle.dart` | Confetti animation data |

---

## 14. Firebase Firestore Structure

```
Firestore
├── users/
│   └── {uid}/
│       ├── uid: string
│       ├── username: string
│       ├── email: string
│       ├── bio: string
│       ├── avatarUrl: string
│       ├── Coin: number
│       ├── XP: number
│       ├── Stars: number
│       ├── CompletedSections: number
│       ├── QuizLevelsInSection: number
│       ├── unlockedCategories: array<string>
│       ├── isGuest: boolean
│       └── createdAt: timestamp
│
├── usernames/
│   └── {username_lowercase}/
│       └── uid: string
│
├── streaks/
│   └── {uid}/
│       ├── currentDay: number
│       ├── rewardClaimed: boolean
│       ├── lastLoginDate: string (ISO date)
│       └── updatedAt: timestamp
│
├── quizzes/
│   └── {quizId}/
│       ├── category: string          (e.g. "Player Quiz")
│       └── levels/
│           └── {levelId}/
│               ├── levelNumber: number
│               ├── isBonus: boolean
│               └── questions/
│                   └── {questionId}/
│                       ├── question: string
│                       ├── options: array<string>
│                       ├── correctAnswer: string
│                       └── imageUrl: string (optional)
│
└── user_progress/
    └── {uid}/
        └── categories/
            └── {categoryId}/
                └── levels/
                    └── {levelId}/
                        ├── completed: boolean
                        ├── stars: number
                        └── completedAt: timestamp
```

### Firestore Security Rules

The project includes `firestore.rules` which governs read/write access. Rules enforce:
- Users can only read/write their own `users/{uid}` document
- Username reservation in `usernames` collection
- Level progress stored under `user_progress/{uid}`
- Leaderboard reads are public (authenticated users)

---

## 15. Assets

### Images (`assets/images/`)

#### Player Images
`ronaldo.png`, `lm10.jpeg`, `vini.jpeg`, `cr7.jpeg`, `kdb.jpeg`, `martinodegaard.jpeg`, `andycole.jpeg`, `zinedinezidane.jpeg`, `hk.jpeg`, `njr.jpeg`, `ts.jpeg`, `romario.jpeg`, `sb.jpeg`, `pdl.jpeg`, `w.jpeg`, `aa.jpeg`, `a.jpeg`, `ss.jpeg`, `es.jpeg`, `cn.jpeg`, `sip.jpeg`

#### Club Logos
`arsenal.jpeg`, `atletico.jpeg`, `barcelona.jpeg`, `chelsea.jpeg`, `dortmund.jpeg`, `juventus.jpeg`, `liverpool.jpeg`, `man_city.jpeg`, `psg.jpeg`, `real_madrid.jpeg`

#### Category Thumbnails
`quiz.jpg`, `stadium.jpg`, `club.jpg`, `national.jpg`, `legend.jpg`, `manager.jpg`, `transfer.png`, `ucl.jpg`, `ballon.jpg`, `world.jpg`, `goalkeeper.png`, `goldenboot.jpg`, `derby.jpg`, `tactuse.png`, `assists.png`, `finals.jpg`, `jursey.jpg`, `logomatser.jpg`, `ot.jpeg`

#### UI Assets
`profile.png` (default avatar), `daily_bonus_coins.png` (bonus card graphic)

### SVG Assets (`assets/svg/`)
| File | Usage |
|---|---|
| `football.svg` | Football icon, general branding |
| `coin-svgrepo-com.svg` | Coin icon in app bar and rewards |
| `gift.svg` | Gift icon for daily bonus / rewards |
| `arrow.svg` | Navigation arrows |
| `dot.svg` | Progress dots / indicators |

### Fonts (`assets/fonts/`)
| File | Style |
|---|---|
| `Inter-VariableFont_opsz,wght.ttf` | Regular (all weights) |
| `Inter-Italic-VariableFont_opsz,wght.ttf` | Italic |

---

*Documentation generated for Football Quiz Game v1.0.0 — Flutter project*
