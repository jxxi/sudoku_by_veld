# Store Listing — Sudoku by Veld

## App name
**Sudoku by Veld**

## Subtitle (iOS, 30 chars max)
**Earthy puzzles & field notes**

## Short description (Google Play, 80 chars)
Unhurried Sudoku with a warm veld feel, field notes, and guided learning.

## Full description

Sudoku by Veld is a calm take on classic 9×9 Sudoku — warm sand tones, sage greens, and room to think.

**Play your way**
- Five difficulties: Easy, Medium, Hard, Expert, and Diabolical — all unlocked
- Curated puzzle packs with rotating variety
- Continue where you left off

**Learn as you go**
- Short interactive walkthrough for first-time players
- Field Notes strategy guide with visual diagrams
- Unlimited hints: strategy patterns or reveal a cell

**Thoughtful details**
- Row, column, and box highlights when you select a cell
- Same-number scanning across the grid
- Pencil marks for notes
- Best times tracked per difficulty
- Optional tip jar to support development — everything stays free

No ads. No account required. Works offline.

## Keywords (iOS)
sudoku, puzzle, logic, brain, calm, offline, veld, strategy, notes, easy

## Category
Games → Puzzle

## Age rating
4+ / Everyone

## Privacy policy URL
Host `docs/PRIVACY_POLICY.md` at a public URL before submission (GitHub Pages, Notion, or your site).

## Screenshots to capture (6.7" iPhone + Android phone)

1. **Home** — stats, New game, Learn
2. **Game** — grid with selection highlights mid-puzzle
3. **Learn → Field Notes** — strategy card with 4×4 diagram
4. **Difficulty picker** — all five tiers
5. **Walkthrough** — coached tutorial step
6. **Completion** — celebration + time dialog

## App icon brief

- **Background:** warm sand `#F4F0E6`
- **Mark:** stylized 3×3 grid or single sage leaf/eco motif `#6B7F5E`
- **Feel:** flat, organic, not neon; no harsh black borders
- **Sizes:** provide 1024×1024 master; use `flutter_launcher_icons` to generate platform sizes

### Generate icons (after adding a 1024×1024 `assets/icon/app_icon.png`)

```yaml
# pubspec.yaml dev_dependencies
flutter_launcher_icons: ^0.14.3

flutter_launcher_icons:
  android: true
  ios: true
  image_path: assets/icon/app_icon.png
  adaptive_icon_background: "#F4F0E6"
  adaptive_icon_foreground: assets/icon/app_icon.png
```

```bash
dart run flutter_launcher_icons
```

## Tip jar SKU
- **Product ID:** `veld_tip_jar`
- **Type:** Non-consumable
- **Suggested price:** $2.99 USD

## Pre-submission checklist

- [ ] Replace placeholder email in privacy policy
- [ ] Host privacy policy URL
- [ ] App icon + splash screen
- [ ] Screenshots (light mode)
- [ ] TestFlight / internal testing build
- [ ] Restore purchases tested on iOS
- [ ] Tip jar product created in App Store Connect + Play Console
