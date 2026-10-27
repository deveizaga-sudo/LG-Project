import SwiftUI

struct TopicView: View {
    let topic: Topic
    @Environment(ProgressStore.self) private var progress

    var body: some View {
        VStack(spacing: 28) {
            Spacer(minLength: 0)
            Text(topic.emoji)
                .font(.system(size: 110))
            VStack(spacing: 6) {
                Text(topic.title)
                    .font(Theme.title(44))
                    .foregroundStyle(Theme.ink)
                Text(topic.subtitle)
                    .font(Theme.body(20))
                    .foregroundStyle(Theme.inkSoft)
                StarsView(count: progress.stars(for: topic), size: 28)
                    .padding(.top, 6)
            }

            VStack(spacing: 16) {
                NavigationLink {
                    FlashcardsView(topic: topic)
                } label: {
                    ModeButton(icon: "book.fill", title: "Aprender", subtitle: "Learn the words", color: topic.tintDeep)
                }
                NavigationLink {
                    QuizView(topic: topic)
                } label: {
                    ModeButton(icon: "gamecontroller.fill", title: "Jugar", subtitle: "Play and win stars", color: Theme.accent)
                }
            }
            .buttonStyle(BouncyButtonStyle())
            .frame(maxWidth: 480)
            Spacer(minLength: 0)
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.background.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct ModeButton: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color

    var body: some View {
        HStack(spacing: 18) {
            Image(systemName: icon)
                .font(.system(size: 30, weight: .bold))
                .frame(width: 44)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(Theme.title(28))
                Text(subtitle)
                    .font(Theme.body(16))
                    .opacity(0.9)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 22, weight: .bold))
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 24)
        .padding(.vertical, 20)
        .background(color, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: color.opacity(0.35), radius: 8, y: 5)
        .accessibilityElement(children: .combine)
    }
}
