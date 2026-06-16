# Sudoku by Veld

Earthy Sudoku for Android and iOS — built with Flutter.

## First-time setup

Flutter was not available in the automated dev environment. On your machine:

```powershell
cd C:\Users\Jasmine\Projects\sudoku_by_veld

# Generate android/, ios/, etc. (keeps existing lib/ and pubspec.yaml)
flutter create . --org com.veld --project-name sudoku_by_veld

flutter pub get
flutter run
```

If `flutter` is not recognized, install the SDK from https://docs.flutter.dev/get-started/install/windows and add `flutter\bin` to your PATH.

## What's included

- **Veld theme** — sand, sage, ochre palette
- **Home** — New game, Learn, per-difficulty stats (best time + completed)
- **5 difficulties** — Easy, Medium, Hard, Expert, Diabolical (all unlocked)
- **Grid** — sage selected cell, row/column/box highlight, same-number highlight, red mistake digits
- **Hints** — Strategy (naked/hidden single) or Reveal cell; unlimited
- **Learn** — Walkthrough tab (stub) + Field Notes strategy cards
- **Tip jar** — IAP stub (`veld_tip_jar`); configure in App Store Connect / Play Console
- **Curated puzzles** — starter pack in `assets/puzzles/puzzles.json`

## Next up

- Interactive tutorial overlay
- More curated puzzles per difficulty
- Timer visibility toggle persistence
- Store assets + TestFlight / internal testing

## Tip jar product ID

`veld_tip_jar` — non-consumable, suggested price $2.99–3.99
