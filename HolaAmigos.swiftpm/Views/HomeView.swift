import SwiftUI

struct HomeView: View {
    @Environment(ProgressStore.self) private var progress

    private let columns = [GridItem(.adaptive(minimum: 150), spacing: 16)]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(Vocabulary.topics) { topic in
                            NavigationLink(value: topic) {
                                TopicCard(topic: topic, stars: progress.stars(for: topic))
                            }
                            .buttonStyle(BouncyButtonStyle())
                            .accessibilityIdentifier("topic-\(topic.id)")
                        }
                    }
                }
                .padding(20)
            }
            .background(Theme.background.ignoresSafeArea())
            .navigationDestination(for: Topic.self) { topic in
                TopicView(topic: topic)
            }
        }
        .tint(Theme.accent)
    }

    private var header: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text("¡Hola, amigos!")
                    .font(Theme.title(38))
                    .foregroundStyle(Theme.ink)
                Text("Let's learn Spanish")
                    .font(Theme.body(18))
                    .foregroundStyle(Theme.inkSoft)
            }
            Spacer()
            HStack(spacing: 6) {
                Image(systemName: "star.fill")
                    .foregroundStyle(Theme.gold)
                Text("\(progress.totalStars)")
                    .contentTransition(.numericText())
            }
            .font(Theme.title(24))
            .foregroundStyle(Theme.ink)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(.white, in: Capsule())
            .shadow(color: .black.opacity(0.08), radius: 6, y: 3)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("\(progress.totalStars) stars earned")
        }
        .padding(.top, 8)
    }
}

struct TopicCard: View {
    let topic: Topic
    let stars: Int

    var body: some View {
        VStack(spacing: 10) {
            Text(topic.emoji)
                .font(.system(size: 64))
            Text(topic.title)
                .font(Theme.title(24))
                .foregroundStyle(.white)
            Text(topic.subtitle)
                .font(Theme.body(15))
                .foregroundStyle(.white.opacity(0.9))
            StarsView(count: stars, size: 18)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(.white.opacity(0.9), in: Capsule())
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 22)
        .background(
            LinearGradient(colors: [topic.tint, topic.tintDeep], startPoint: .top, endPoint: .bottom),
            in: RoundedRectangle(cornerRadius: 28, style: .continuous)
        )
        .shadow(color: topic.tintDeep.opacity(0.35), radius: 10, y: 6)
        .accessibilityElement(children: .combine)
    }
}
