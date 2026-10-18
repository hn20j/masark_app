# مسارك (Masarak) — Flutter App

An AI-powered job application assistant: the user uploads their CV, and the
in-app "agent" matches it against jobs and auto-submits applications to
companies in their home country.

This project implements the 5 wireframes you shared (onboarding, login,
sign up, home dashboard, CV upload) plus the additional screens a product
like this needs end-to-end.

## Screens included

| Screen | File | Notes |
|---|---|---|
| Splash | `lib/screens/splash_screen.dart` | Brand intro, auto-navigates |
| Onboarding | `lib/screens/onboarding_screen.dart` | 3-page swipeable intro (wireframe 1, extended) |
| Login | `lib/screens/login_screen.dart` | Wireframe 2 |
| Sign up | `lib/screens/signup_screen.dart` | Wireframe 3 |
| Home dashboard | `lib/screens/home_screen.dart` | Wireframe 4 + bottom nav shell |
| CV upload | `lib/screens/cv_upload_screen.dart` | Wireframe 5, uses `file_picker` |
| **CV / preferences builder** *(new)* | `lib/screens/cv_builder_screen.dart` | Captures target role, skills, target country — the data the agent needs to search & apply |
| **Job listings** *(new)* | `lib/screens/job_listings_screen.dart` | Search + filter feed of matched jobs |
| **Job details** *(new)* | `lib/screens/job_details_screen.dart` | "قدّم عني الآن" — triggers the agent's auto-apply action |
| **Applications tracker** *(new)* | `lib/screens/applications_screen.dart` | Status pipeline: submitted → viewed → interview → offer |
| **Profile / settings** *(new)* | `lib/screens/profile_screen.dart` | CV, preferences, agent auto-apply toggle, sign out |

### Why the extra pages
The wireframes covered onboarding and the CV upload prompt, but a working
"agent applies for you" product also needs:
- A place to capture **target job / skills / target country** — an agent
  can't search intelligently from a raw PDF alone.
- A **job feed** to browse/search matches (with an AI match-score badge).
- A **details + apply** screen where the auto-apply action actually lives.
- An **applications tracker** so the user can see what the agent has done
  on their behalf (this is the core trust-building surface of the app).
- A **profile/settings** screen, including a toggle for how autonomous the
  agent is allowed to be (auto-apply vs. review-before-send).

## Architecture

- **State management:** `provider` (`lib/theme/app_state.dart`) — a single
  `AppState` holds the signed-in user and agent settings. Swap this for
  Riverpod/Bloc if you prefer; the pattern is intentionally simple.
- **Models:** `lib/models/models.dart` — `AppUser`, `Job`, `Application`,
  plus `DemoData` with sample jobs/applications so every screen renders
  without a backend.
- **Theme:** `lib/theme/app_theme.dart` — all colors, gradients, and shared
  button widgets (`PrimaryButton`, `PinkButton`, `OutlineButton`) live here
  so the app stays visually consistent with the wireframes (deep indigo
  backgrounds, violet primary actions, pink hero CTA).
- **RTL/Arabic:** the whole app is forced into `Locale('ar')` +
  `TextDirection.rtl` in `main.dart`, matching the wireframes.
- **Push notifications:** Firebase Cloud Messaging is configured for Android.
  Enable notifications from Profile to request permission and copy the device's
  FCM token; use that token in Firebase Console's Messaging test-send flow.
  Foreground notifications are displayed locally. The token is device-specific;
  sending to users across devices requires storing tokens in a trusted backend
  and sending through the Firebase Admin SDK.

## Wiring in a real backend

Everything currently runs on local demo data so the UI is fully clickable
out of the box. To make it real:

1. **Auth** — login and sign-up currently use local demo state. Any valid email
  and password of at least 6 characters can continue; the profile stays in
  memory for the current session and credentials are not stored. Connect an
  auth provider (Firebase Auth, Supabase, or a custom REST API) when real
  accounts are needed.
2. **CV storage** — `cv_upload_screen.dart` already picks a file via
   `file_picker`; upload `result.files.first.bytes` (or the path) to your
   storage (e.g. Firebase Storage / S3) and store the URL on the user.
3. **The agent** — `job_details_screen.dart`'s `_applyWithAgent()` is the
   integration point: call your backend job (e.g. a Cloud Function or
   server job queue) that runs CV-parsing + matching + auto-submission,
   then update `Application.status` from real webhook/callback events
   instead of the local `DemoData` list.
4. **Job data** — replace `DemoData.jobs` with a live jobs API/feed.

## Getting started

```bash
# 1. Make sure Flutter is installed: https://docs.flutter.dev/get-started/install
flutter --version

# 2. From this folder, scaffold the native platform folders (android/ios/etc)
#    — they're intentionally not included since they're auto-generated:
flutter create .

# 3. Get packages
flutter pub get

# 4. Run
flutter run
```

### Dependencies used (see `pubspec.yaml`)
- `google_fonts` — Cairo, an Arabic-friendly typeface
- `file_picker` — native file picker for CV upload
- `provider` — state management
- `flutter_localizations` — RTL/Arabic locale support
- `intl`, `flutter_svg`, `percent_indicator` — available for further polish
  (date formatting, icons, progress rings)

## Notes / things to customize next
- Add real form validation + backend error handling on login/signup.
- Add push notifications for application status changes.
- Add a "why this match" explainer on the job details screen (transparency
  into what the AI matched on builds trust for an autonomous agent).
- Consider a review queue ("pending approval") before auto-apply if you
  want the agent to ask permission before submitting, per the toggle in
  the Profile screen.
