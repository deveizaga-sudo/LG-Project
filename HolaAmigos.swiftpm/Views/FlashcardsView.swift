import SwiftUI

/// Swipe through the topic's words; each card is read aloud as it appears
/// and again whenever it's tapped.
@MainActor
struct FlashcardsView: View {
    let topic: Topic
    @State private var index = 0

    var body: some View {
        VStack(spacing: 16) {
            TabView(selection: $index) {
                ForEach(Array(topic.words.enumerated()), id: \.element.id) { i, word in
                    WordCard(word: word, topic: topic)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 48)
                        .tag(i)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))

            Text("\(index + 1) / \(topic.words.count)")
                .font(Theme.body(18))
                .foregroundStyle(Theme.inkSoft)
                .padding(.bottom, 12)
        }
        .background(Theme.background.ignoresSafeArea())
        .navigationTitle("Aprender")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { speakCurrent() }
        .onChange(of: index) { speakCurrent() }
    }

    private func speakCurrent() {
        guard topic.words.indices.contains(index) else { return }
        Speaker.shared.say(topic.words[index].spanish)
    }
}

@MainActor
private struct WordCard: View {
    let word: Word
    let topic: Topic
    @State private var bounce = 0

    var body: some View {
        Button {
            bounce += 1
            Haptics.tap()
            Speaker.shared.say(word.spanish, slow: true)
        } label: {
            VStack(spacing: 18) {
                Text(word.emoji)
                    .font(.system(size: 140))
                    .phaseAnimator([1.0, 1.2], trigger: bounce) { content, scale in
                        content.scaleEffect(scale)
                    } animation: { _ in
                        .spring(response: 0.25, dampingFraction: 0.5)
                    }
                Text(word.spanish)
                    .font(Theme.title(48))
                    .foregroundStyle(Theme.ink)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.6)
                Text(word.english)
                    .font(Theme.body(22))
                    .foregroundStyle(Theme.inkSoft)
                Label("Tap to hear", systemImage: "speaker.wave.2.fill")
                    .font(Theme.body(16))
                    .foregroundStyle(topic.tintDeep)
                    .padding(.top, 4)
            }
            .padding(32)
            .frame(maxWidth: 520, maxHeight: .infinity)
            .background(.white, in: RoundedRectangle(cornerRadius: 36, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 36, style: .continuous)
                    .stroke(topic.tint, lineWidth: 6)
            )
            .shadow(color: .black.opacity(0.08), radius: 12, y: 6)
        }
        .buttonStyle(BouncyButtonStyle())
        .accessibilityLabel("\(word.spanish), \(word.english)")
        .accessibilityHint("Plays the Spanish word")
        .accessibilityIdentifier("flashcard-\(word.id)")
    }
}
