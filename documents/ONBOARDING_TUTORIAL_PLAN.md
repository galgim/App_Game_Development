# Onboarding & Tutorial — Implementation Plan

## Overview

When a player opens the app for the first time they are guided into the game through
an **onboarding screen** and an optional **interactive tutorial**. Returning players
skip straight to the main menu with their name already filled in.

---

## App Launch Decision Tree

```
App starts
    ↓
Read SharedPreferences
    │
    ├─ hasPlayedBefore = false  →  OnboardingScreen
    │                                   │
    │                         Enter your name
    │                                   │
    │                   "Is this your first time?"
    │                       ┌───────────┴───────────┐
    │                    YES │                       │ NO
    │                       ↓                       ↓
    │               TutorialScreen           MainMenuScreen
    │               (6 guided slides              (name
    │              + in-game hint)              pre-filled)
    │                       ↓
    │               MainMenuScreen
    │
    └─ hasPlayedBefore = true   →  MainMenuScreen
                                    (name pre-filled from prefs)
```

---

## SharedPreferences Keys

| Key               | Type   | Purpose                              |
|-------------------|--------|--------------------------------------|
| `hasPlayedBefore` | bool   | Whether to skip onboarding on launch |
| `playerName`      | string | Pre-fill the name field on menu      |

Both are written the moment the player taps YES or NO on the onboarding screen —
**before** the tutorial starts, so a force-close during tutorial does not loop
back to onboarding.

---

## Screen: OnboardingScreen

**File:** `lib/screens/onboarding_screen.dart`

Shown only on first launch. Layout:

```
┌──────────────────────────────┐
│          TRIPLE              │
│           SEVEN              │
│        [card fan art]        │
│                              │
│    ┌────────────────────┐    │
│    │ What's your name?  │    │  ← TextField, max 14 chars
│    └────────────────────┘    │
│                              │
│  Is this your first time     │
│      playing Triple Seven?   │
│                              │
│  ┌──────────┐ ┌────────────┐ │
│  │YES—SHOW  │ │NO — LET'S │ │  ← two equal-width buttons
│  │   ME     │ │    GO     │ │
│  └──────────┘ └────────────┘ │
└──────────────────────────────┘
```

**Behaviour:**
- YES → save prefs → navigate to `TutorialScreen`
- NO  → save prefs → navigate to `MainMenuScreen`
- Name defaults to `'You'` if left blank

---

## Screen: TutorialScreen

**File:** `lib/screens/tutorial_screen.dart`

A 6-slide carousel. A progress bar at the top fills as the player advances.
Each slide has an illustration widget, a large title, and explanatory body text.
NEXT advances; the final slide shows START PLAYING which pushes `GameScreen`
with `tutorialMode: true`.

### Slides

| # | Title                   | Key Concept                                 |
|---|-------------------------|---------------------------------------------|
| 0 | Welcome!                | Goal — collect 3 sets before the AI         |
| 1 | The Deck                | 36 cards, 1–12 × 3 each; a set = 3 matching |
| 2 | On Your Turn            | Reveal 2 cards from opponent / middle / self |
| 3 | Match = Bonus Pick!     | 2 matching → earn a 3rd reveal              |
| 4 | No Match? They Flip Back| Unmatched cards reset; AI watches everything |
| 5 | First to 3 Sets Wins    | Win with 3 sets or instant Triple Seven      |

---

## In-Game Tutorial Hint (tutorialMode)

**File:** `lib/screens/game_screen.dart`

When `GameScreen` is launched with `tutorialMode: true`:

1. A dark pill-shaped banner appears at the bottom of the game board
2. Its message updates live based on game state:

| State                           | Banner message                                               |
|---------------------------------|--------------------------------------------------------------|
| picksThisTurn == 0              | "Your turn — reveal 2 cards. Tap Hi/Lo, middle, or your own." |
| picksThisTurn == 1              | "Good! Now reveal one more card."                            |
| bonusTriggered == true          | "🔥 Match! Find the 3rd card anywhere to collect a set."    |
| currentPlayerIndex != 0 (AI)    | "Great! Watch the AI take their turn. Good luck!"           |

3. The banner uses `IgnorePointer` so it **never blocks card taps**
4. After the player's first turn ends, the banner auto-dismisses after 3 seconds
5. The banner is hidden if the game-over overlay appears

---

## MainMenuScreen Changes

**File:** `lib/screens/menu_screen.dart`

- Accepts a `playerName` parameter (default `'You'`) — pre-fills the name field
- Saves the name back to SharedPreferences each time PLAY is tapped
- **HOW TO PLAY button removed** — the tutorial replaces it
- `CardBackFan` widget made public (renamed from `_CardBackFan`) so onboarding can reuse it

---

## Files Changed / Created

| File                                   | Change                                          |
|----------------------------------------|-------------------------------------------------|
| `pubspec.yaml`                         | Add `shared_preferences` dependency             |
| `lib/main.dart`                        | Async init; reads prefs; routes to correct home |
| `lib/screens/onboarding_screen.dart`   | **New** — first-launch name + question screen   |
| `lib/screens/tutorial_screen.dart`     | **New** — 6-slide tutorial carousel             |
| `lib/screens/menu_screen.dart`         | Accept playerName; save prefs; remove HOW button |
| `lib/screens/game_screen.dart`         | Add tutorialMode; in-game hint banner           |
