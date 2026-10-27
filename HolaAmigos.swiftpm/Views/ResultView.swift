import SwiftUI

@MainActor
struct ResultView: View {
    let topic: Topic
    let stars: Int
    let bestStreak: Int
    let playAgain: () -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var shownStars = 0
    @State private var celebration = 0

    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                Spacer(minLength: 0)
                Text("🏆")
                    .font(.system(size: 100))
                VStack(spacing: 6) {
                    Text("¡Terminaste!")
                        .font(Theme.title(44))
                        .foregroundStyle(Theme.ink)
                    Text("You finished \(topic.subtitle.lowercased())!")
                        .font(Theme.body(20))
                        .foregroundStyle(Theme.inkSoft)
                }

                HStack(spacing: 10) {
                    ForEach(0..<3, id: \.self) { i in
                        Image(systemName: i < shownStars ? "star.fill" : "star")
                            .font(.system(size: 64, weight: .bold))
                            .foregroundStyle(i < shownStars ? Theme.gold : Theme.inkSoft.opacity(0.3))
                            .scaleEffect(i < shownStars ? 1 : 0.8)
                    }
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("\(stars) of 3 stars")

                if bestStreak >= 2 {
                    Text("🔥 Best streak: \(bestStreak)")
                        .font(Theme.body(20))
                        .foregroundStyle(Theme.ink)
                }

                Spacer(minLength: 0)

                VStack(spacing: 14) {
                    Button(action: playAgain) {
                        Label("Jugar otra vez", systemImage: "arrow.clockwise")
                            .font(Theme.title(24))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, minHeight: 64)
                            .background(Theme.accent, in: Capsule())
                    }
                    Button {
                        dismiss()
                    } label: {
                        Text("Volver")
                            .font(Theme.title(22))
                            .foregroundStyle(Theme.ink)
                            .frame(maxWidth: .infinity, minHeight: 58)
                            .background(.white, in: Capsule())
                    }
                }
                .buttonStyle(BouncyButtonStyle())
                .frame(maxWidth: 420)
            }
            .padding(24)

            ConfettiBurst(trigger: celebration)
        }
        .task {
            // Reveal the stars one at a time, each with its own little reward.
            for i in 0..<stars {
                try? await Task.sleep(for: .milliseconds(450))
                withAnimation(.spring(response: 0.35, dampingFraction: 0.5)) {
                    shownStars = i + 1
                }
                Haptics.tap()
            }
            celebration += 1
            Speaker.shared.say(stars == 3 ? "¡Perfecto!" : "¡Buen trabajo!")
        }
    }
}
