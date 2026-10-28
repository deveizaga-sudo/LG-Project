# Hola Amigos — Spanish for kids (iOS)

A simple iPhone and iPad app that teaches kids aged about 4–8 their first Spanish words. Short rounds and a reward on every right answer keep them coming back.

## What's in it

- **6 topics:** Colores, Animales, Números, Comida, Familia and El cuerpo, with 7–10 words each. Nouns include their article ("el perro", "la vaca") so kids learn the gender with the word.
- **Aprender (Learn):** swipe through big picture cards. Each word is read aloud in Spanish as the card appears, and again (slowly) when tapped.
- **Jugar (Play):** rounds of 8 quick questions, alternating between:
  - **Hear it:** the word is spoken and shown, and the child taps the matching picture.
  - **See it:** a picture is shown, and the child taps the Spanish word.
- **Quick rewards:**
  - A right answer brings confetti, spoken praise ("¡Muy bien!", "¡Genial!"), a haptic buzz and a 🔥 streak counter.
  - A wrong answer never ends the round. The card wiggles, the app says the word that was tapped, and the child tries again.
  - Each round earns 1–3 stars, based on answers right on the first try. Stars add up on the home screen, and replaying can only raise a topic's best score.
- **Kid-safe:** no ads, no purchases, no accounts, no web links, and no network access. Speech uses the device's built-in Spanish voice, and progress is saved only on the device.

## Run it

`HolaAmigos.swiftpm` is a Swift Playgrounds app package. Either of these works:

- **iPad or Mac with Swift Playgrounds** (free, version 4.4 or later): copy the `HolaAmigos.swiftpm` folder to the device, open it in Swift Playgrounds and press ▶︎.
- **Mac with Xcode 15 or later:** open `HolaAmigos.swiftpm` in Xcode, pick an iPhone or iPad simulator and press Run. To run on a real device, select your team under *Signing & Capabilities*.

It needs iOS/iPadOS 17 or later. If the Spanish voice sounds robotic, download a better one on the device under **Settings → Accessibility → Spoken Content → Voices → Spanish**.

## Testing on GitHub (works from Windows)

Every push triggers the **iOS build & test** workflow (`.github/workflows/ios.yml`). It runs on one of GitHub's Macs and:

1. builds the app with Xcode,
2. runs the logic tests in `Tests/HolaAmigosTests` (quiz rules, stars and saved progress),
3. plays through the app in an iPhone simulator (`Tests/HolaAmigosUITests`): it opens Animales, swipes the flashcards, plays a full round including one wrong answer, and checks the results screen,
4. saves a screenshot of every screen.

To see the results:

1. Open the repository on github.com and click the **Actions** tab.
2. Click the latest **iOS build & test** run. A green check means everything passed; a red ✗ shows which step failed.
3. Scroll to **Artifacts** at the bottom of the run page and download **screenshots**. It's a zip of PNGs you can open on any computer.

To start a run without pushing code, click **Run workflow** on the workflow's page. The Xcode project is generated on the fly from `project.yml` with XcodeGen, so there's nothing extra to keep in sync.

## Project layout

```
HolaAmigos.swiftpm/
  Package.swift              app settings (name, bundle ID, icon, orientations)
  App/HolaAmigosApp.swift    entry point
  Models/
    Vocabulary.swift         all topics and words (edit here to add content)
    Quiz.swift               question builder, star rules, round state
    ProgressStore.swift      best stars per topic, saved on the device
  Services/
    Speaker.swift            Spanish text-to-speech
    Haptics.swift            tap and success vibrations
  Views/                     Home, Topic, Flashcards, Quiz, Result, confetti, theme
  Assets.xcassets            app icon and accent color
```

### Adding words or topics

Edit `Models/Vocabulary.swift`. Each topic needs at least 3 words, since every question shows 3 choices, and emoji work as pictures. To change the round length or the number of choices, edit `QuizBuilder.questionCount` and `QuizBuilder.choiceCount` in `Models/Quiz.swift`.

## Publishing

Before submitting to the App Store:

1. Change `bundleIdentifier` in `Package.swift` to one you own, and set your `teamIdentifier`.
2. In App Store Connect, choose the **Kids** category and an age band (5 & Under or 6–8).
3. Privacy label: **Data Not Collected**.

Swift Playgrounds on iPad or Mac can upload the app to App Store Connect directly.
