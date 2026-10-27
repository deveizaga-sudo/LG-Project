# LG Project Home — webOS TV layout

A home-screen layout for LG TVs (webOS), built as a plain HTML/CSS/JS web app at 1920×1080. It needs no build step and has no dependencies.

![Home screen](docs/home.png)

## Layout

```
┌──────┬───────────────────────────────────────────────────────────┐
│      │  Greeting · Profile                    Search Bell ⚙ 9:41 │  top bar
│  LG  │                                                           │
│      │  NEW SEASON                                               │
│ Home │  Northern Lights                                          │  hero
│ Live │  2026 · Drama · 4K HDR                                    │  (auto-rotating,
│ Apps │  [▶ Watch now]  [ⓘ More info]                             │   tints backdrop)
│ Inp. │  ● ○ ○                                                    │
│ Srch │  Continue watching  ▭ ▭ ▭ ▭  (progress bars)              │
│ Sett │  Apps               ▢ ▢ ▢ ▢ ▢ ▢                           │  rows
│      │  Recommended        ▯ ▯ ▯ ▯ ▯ ▯ ▯                         │  (scroll with focus)
│ rail │  Inputs             HDMI 1 · HDMI 2 · USB · Antenna       │
└──────┴───────────────────────────────────────────────────────────┘
```

- **Left rail**: shows only icons, and expands to show labels while it has focus.
- **Hero**: a featured carousel that also tints the full-screen backdrop. It stops rotating while its buttons have focus.
- **Rows**: poster (2:3), wide (16:9), app tile and input tile styles. Rows scroll sideways and the page scrolls down to keep the focused card in view.
- **Details modal** and **exit confirmation**: focus stays inside them while open.
- **Safe area**: 64px horizontal and 48px vertical margins to allow for overscan.

## Remote control

| Key | Action |
| --- | --- |
| Arrow keys | Spatial navigation (`js/navigation.js`) |
| OK / Enter | Select |
| Back (`461`) | Close an overlay, then return to the top, then show the exit dialog |
| Magic Remote pointer | Hover moves focus and click selects. `cursorStateChange` switches between pointer and D-pad mode |

In a desktop browser, Backspace and Esc act as Back.

## Project structure

```
appinfo.json        webOS app manifest (disableBackHistoryAPI so Back is handled in JS)
index.html          stage markup
css/styles.css      layout, focus states, theme tokens
js/icons.js         inline SVG icon set
js/data.js          rail, featured and row content (replace with real data)
js/navigation.js    D-pad spatial navigation + Magic Remote pointer
js/app.js           rendering, scrolling, carousel, modals, clock
icon.png / largeIcon.png
```

## Run

**Browser:** open `index.html`. The stage scales to fit any window size.

**TV / emulator** (with the [webOS TV CLI](https://webostv.developer.lge.com/develop/tools/cli-installation)):

```sh
ares-package .
ares-install --device <tv> com.lgproject.home_1.0.0_all.ipk
ares-launch  --device <tv> com.lgproject.home
```
