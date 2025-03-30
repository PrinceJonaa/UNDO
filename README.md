# UNDO - Release the Moment

## 🧠 Concept Summary

UNDO is a minimalist mobile application designed as a tool for symbolic release and mindfulness. It allows users to acknowledge a thought, feeling, or memory they wish to let go of, type it into the app, and perform a symbolic "undo" action.

The core principle is **ephemerality**. There is no saving, no history, no tracking, and no data collection. Once a moment is "undone," it vanishes from the app entirely. The focus is on the intentional act of release, not on creating a journal or archive.

The app encourages a ritualistic approach by limiting submissions to one per day.

## ✨ Core Features

*   **Home Screen:** Minimalist entry point with a single button ("Release a Moment") and access to settings.
*   **Input Screen:** A simple prompt ("What are you ready to let go of?") and a text field for the user's input.
*   **Undo Action:** Tapping the "Undo" button triggers a subtle animation and sound (optional), clears the input, and transitions to the confirmation.
*   **Confirmation Screen:** Displays an affirming message ("Done. But if you remember, it’s because you’re ready.") before automatically returning to the Home Screen.
*   **Daily Limit:** Enforces a mindful pace by allowing only one submission per 24-hour period. The button is disabled otherwise.
*   **Ephemeral Data:** No user input is ever stored locally or remotely after the "Undo" action is completed.
*   **Offline First:** The app functions entirely offline, requiring no internet connection.
*   **Settings:** Provides access to basic information (About, Privacy Policy, Terms of Use) and a toggle for the optional sound effect.

## 🧰 Tech Stack

*   **Framework:** Flutter (iOS + Android from a single codebase)
*   **State Management:** StatefulWidget (for local screen state), `shared_preferences` (for daily limit timestamp and sound setting)
*   **Audio:** `audioplayers` package
*   **Fonts:** `google_fonts` package (using Spectral)
*   **Storage:** `shared_preferences` (minimal, non-identifiable data for settings/limit)
*   **Backend:** None

## 🎨 Design Principles

*   **Aesthetic:** Clean, minimal, sacred-modern.
*   **Color Palette:** Off-white background (`#F8F8F8`), soft indigo/purple accent (`#6A5ACD`).
*   **Font:** Spectral (Serif).
*   **Animation:** Subtle fade-out on "Undo".
*   **Sound (Optional):** Soft sound effect on "Undo".

## 🔐 App Store Considerations

*   **User Utility:** Presented as a mindfulness tool for symbolic release and letting go.
*   **Privacy:** Explicitly states no collection or storage of personal data in the Privacy Policy and app description. All user input is ephemeral.
*   **Permissions:** No special permissions required by default.
*   **Target Audience:** Users interested in mindfulness, meditation, and simple tools for emotional processing.

## 🚀 Getting Started

This project is a standard Flutter application.

1.  Ensure you have the Flutter SDK installed.
2.  Clone the repository.
3.  Navigate to the `undo_app` directory: `cd undo_app`
4.  Install dependencies: `flutter pub get`
5.  Create the audio assets directory: `mkdir -p assets/audio`
6.  Place a sound file (e.g., `undo_sound.mp3`) in `assets/audio/`.
7.  Run the app: `flutter run`