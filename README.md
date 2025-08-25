# FitTrack – Copilot-Based Mini Project (Week 3)

A Flutter mobile app built with prompt-based workflows using GitHub Copilot. FitTrack tracks daily workouts, water intake, and goals, with weekly progress charts and local persistence via SharedPreferences.

## Overview
- Role: Mobile Developers
- Stack: Flutter, Provider, Shared Preferences, fl_chart
- Scope: Local state + mock APIs, inline Copilot for logic, comments, and tests
- Outcome: Fully working app, documented prompt flows, and test coverage

## Features
- Authentication flow wrapper and home shell: [`FitTrackApp`](lib/main.dart), [`AuthWrapper`](lib/main.dart), [`ProfileDrawer`](lib/main.dart)
- Workouts: add with validation (min 10 reps), complete, delete, daily total stored per weekday
  - Screen: [`WorkoutsScreen`](lib/screens/workouts_screen.dart)
- Goals: add, toggle achieved, delete
  - Screen: [`GoalsScreen`](lib/screens/goals_screen.dart)
- Water intake: track daily glasses
  - Screen: [`WaterScreen`](lib/screens/water_screen.dart)
- Progress: weekly charts for workouts and water
  - Screen: [`ProgressScreen`](lib/screens/progress_screen.dart)
- Settings and Help:
  - [`SettingsScreen`](lib/screens/settings_screen.dart)
  - [`HelpScreen`](lib/screens/help_screen.dart)
- State management: [`SettingsProvider`](lib/providers/settings_provider.dart)
- Mock APIs and persistence: [`MockApi`](lib/services/mock_api.dart) using SharedPreferences

## Project Structure
- App entry and navigation: [`lib/main.dart`](lib/main.dart)
- Screens:
  - Workouts: [`lib/screens/workouts_screen.dart`](lib/screens/workouts_screen.dart)
  - Goals: [`lib/screens/goals_screen.dart`](lib/screens/goals_screen.dart)
  - Water: [`lib/screens/water_screen.dart`](lib/screens/water_screen.dart)
  - Progress: [`lib/screens/progress_screen.dart`](lib/screens/progress_screen.dart)
  - Help: [`lib/screens/help_screen.dart`](lib/screens/help_screen.dart)
  - Settings: [`lib/screens/settings_screen.dart`](lib/screens/settings_screen.dart)
- Services: [`lib/services/mock_api.dart`](lib/services/mock_api.dart)
- Tests: [`test/widget_test.dart`](test/widget_test.dart)
- Web shell: [`web/index.html`](web/index.html)

## Mock API Details
- Storage keys:
  - Workouts: `workouts` (List<String>, JSON per workout)
  - Goals: `goals` (List<String>, JSON per goal)
  - Water: `waterIntake` (int)
  - Legacy single goal: `goal` (String)
- API: [`MockApi`](lib/services/mock_api.dart)

## Notable Behaviors
- Workouts
  - Minimum 10 reps enforced in [`WorkoutsScreen._addWorkout`](lib/screens/workouts_screen.dart)
  - Completing a workout shows SnackBar and updates weekly totals in SharedPreferences
- Goals
  - Toggling achieved shows a success SnackBar in [`GoalsScreen._toggleGoalAchieved`](lib/screens/goals_screen.dart)
- Progress
  - Animations and charts rendered via fl_chart in [`ProgressScreen`](lib/screens/progress_screen.dart)

## Getting Started
1. Prerequisites: Flutter SDK installed
2. Install dependencies:
   - macOS/Linux: `flutter pub get`
   - Windows: `flutter pub get`
3. Run:
   - Mobile: `flutter run`
   - Web: `flutter run -d chrome`

## Build
- Android: `flutter build apk`
- iOS: `flutter build ios`
- Web: `flutter build web`

## Testing
- Run tests: `flutter test`
- Included cases:
  - Widget smoke test and navigation assertions in [`test/widget_test.dart`](test/widget_test.dart)
  - Mocked API tests for water intake and workouts list

## Prompt Log (Copilot Usage)
- Scaffold app and navigation
  - Prompt: “Create a Flutter app with 4 tabs (Workouts, Goals, Water, Progress) using BottomNavigationBar and Provider for theming.”
- Implement mock persistence
  - Prompt: “Add a MockApi service using SharedPreferences with methods to fetch/save workouts, goals, and water intake.”
- Workouts logic
  - Prompt: “In the workouts screen, validate min 10 reps, allow toggle complete, and store per-day totals for weekly charts.”
- Goals logic
  - Prompt: “Create a goals list with add, toggle achieved, and delete using JSON serialization.”
- Progress screen charts
  - Prompt: “Use fl_chart to render weekly bar charts for workouts and water with animated entrance.”
- Tests
  - Prompt: “Write widget tests to verify tab navigation labels and mock API return values.”
- Documentation
  - Prompt: “Draft a README that documents prompt flows, blockers, and outcomes for the Week 3 Copilot-based mini project.”

## Blockers and Outcomes
- Handling JSON decoding errors in persisted lists
  - Outcome: Defensive parsing with try/catch and `whereType<...>()` in [`WorkoutsScreen._loadWorkouts`](lib/screens/workouts_screen.dart) and [`GoalsScreen._loadGoals`](lib/screens/goals_screen.dart)
- Ensuring charts sync with daily updates
  - Outcome: Store per-weekday totals in SharedPreferences; charts read from persisted values in [`ProgressScreen`](lib/screens/progress_screen.dart)

## VS Code Tips
- Tasks: see [fittrack/.vscode/tasks.json](.vscode/tasks.json)
- Debug: launch configs in [fittrack/.vscode/launch.json](.vscode/launch.json)

## Copilot Instructions
- Custom instructions: [.github/copilot-instructions.md](.github/copilot-instructions.md)

## Export PDF
- Option 1: Print this README to PDF from VS Code (Markdown: Open Preview to the Side → Print).
- Option 2: `pandoc README.md -o FitTrack-Summary.pdf`

## License
MIT (or update as needed)
