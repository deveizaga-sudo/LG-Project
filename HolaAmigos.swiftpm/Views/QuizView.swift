import SwiftUI

/// One round of 8 quick questions. Every right answer gets an instant reward
/// (confetti, praise, haptic); wrong picks just wiggle and the child tries again.
@MainActor
struct QuizView: View {
    let topic: Topic

    @Environment(ProgressStore.self) private var progress
    @State private var session: QuizSession
    @State private var celebration = 0
    @State private var praise: String?
    @State private var shakes: [String: Int] = [:]
    @State private var isAdvancing = false

    init(topic: Topic) {
        self.topic = topic
        _session = State(initialValue: QuizSession(topic: topic))
    }

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            if session.isFinished {
                ResultView(
                    topic: topic,
                    stars: session.stars,
                    bestStreak: session.bestStreak,
                    playAgain: restart
                )
                .transition(.scale.combined(with: .opacity))
            } else if let question = session.current {
                VStack(spacing: 24) {
                    statusBar
                    Spacer(minLength: 0)
                    prompt(for: question)
                    Spacer(minLength: 0)
                    choices(for: question)
                }
                .padding(20)
                .frame(maxWidth: 640)
                .id(question.id)
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)).combined(with: .opacity))
            }

            ConfettiBurst(trigger: celebration)

            if let praise {
                Text(praise)
                    .font(Theme.title(46))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 14)
                    .background(Theme.success, in: Capsule())
                    .shadow(color: .black.opacity(0.15), radius: 10, y: 6)
                    .transition(.scale(scale: 0.4).combined(with: .opacity))
                    .allowsHitTesting(false)
            }
        }
        .navigationTitle("Jugar")
        .navigationBarTitleDisplayMode(.inline)
        .task(id: session.current?.id) {
            // Read "hear the word" questions aloud as soon as they appear.
            guard let question = session.current, question.kind == .hearWord else { return }
            try? await Task.sleep(for: .milliseconds(350))
            Speaker.shared.say(question.answer.spanish)
        }
        .onChange(of: session.isFinished) {
            if session.isFinished {
                progress.record(session.stars, for: topic)
            }
        }
    }

    // MARK: - Pieces

    private var statusBar: some View {
        HStack(spacing: 14) {
            ProgressView(value: session.progress)
                .tint(topic.tintDeep)
                .scaleEffect(x: 1, y: 2.2, anchor: .center)
                .animation(.easeInOut, value: session.progress)
            HStack(spacing: 4) {
                Text("🔥")
                Text("\(session.streak)")
                    .contentTransition(.numericText())
                    .animation(.spring, value: session.streak)
            }
            .font(Theme.title(22))
            .foregroundStyle(Theme.ink)
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .background(.white, in: Capsule())
            .scaleEffect(session.streak >= 3 ? 1.12 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: session.streak)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Streak \(session.streak)")
        }
    }

    @ViewBuilder
    private func prompt(for question: QuizQuestion) -> some View {
        switch question.kind {
        case .hearWord:
            VStack(spacing: 16) {
                Text("Find the picture")
                    .font(Theme.body(20))
                    .foregroundStyle(Theme.inkSoft)
                Button {
                    Speaker.shared.say(question.answer.spanish, slow: true)
                } label: {
                    HStack(spacing: 14) {
                        Image(systemName: "speaker.wave.3.fill")
                            .font(.system(size: 30, weight: .bold))
                        Text(question.answer.spanish)
                            .font(Theme.title(40))
                            .minimumScaleFactor(0.6)
                            .lineLimit(1)
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 18)
                    .background(topic.tintDeep, in: Capsule())
                }
                .buttonStyle(BouncyButtonStyle())
                .accessibilityHint("Plays the word again")
            }
        case .seePicture:
            VStack(spacing: 10) {
                Text("¿Qué es?")
                    .font(Theme.title(30))
                    .foregroundStyle(Theme.ink)
                Text("What is it?")
                    .font(Theme.body(18))
                    .foregroundStyle(Theme.inkSoft)
                Text(question.answer.emoji)
                    .font(.system(size: 130))
                    .padding(.top, 6)
                    .accessibilityLabel(question.answer.english)
            }
        }
    }

    @ViewBuilder
    private func choices(for question: QuizQuestion) -> some View {
        switch question.kind {
        case .hearWord:
            HStack(spacing: 14) {
                ForEach(question.choices) { word in
                    choiceButton(word, question: question) {
                        Text(word.emoji)
                            .font(.system(size: 70))
                            .frame(maxWidth: .infinity, minHeight: 130)
                    }
                    .accessibilityLabel(word.english)
                }
            }
        case .seePicture:
            VStack(spacing: 12) {
                ForEach(question.choices) { word in
                    choiceButton(word, question: question) {
                        Text(word.spanish)
                            .font(Theme.title(30))
                            .foregroundStyle(Theme.ink)
                            .frame(maxWidth: .infinity, minHeight: 72)
                    }
                    .accessibilityLabel(word.spanish)
                }
            }
        }
    }

    private func choiceButton<Content: View>(
        _ word: Word,
        question: QuizQuestion,
        @ViewBuilder label: () -> Content
    ) -> some View {
        let isWrong = session.wrongPicks.contains(word.id)
        return Button {
            choose(word)
        } label: {
            label()
                .background(.white, in: RoundedRectangle(cornerRadius: 26, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 26, style: .continuous)
                        .stroke(isWrong ? Color.red.opacity(0.5) : topic.tint, lineWidth: 5)
                )
                .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
                .opacity(isWrong ? 0.35 : 1)
        }
        .buttonStyle(BouncyButtonStyle())
        .disabled(isWrong || isAdvancing)
        .modifier(Shake(animatableData: CGFloat(shakes[word.id] ?? 0)))
    }

    // MARK: - Actions

    private func choose(_ word: Word) {
        guard !isAdvancing else { return }
        switch session.pick(word) {
        case .correct:
            isAdvancing = true
            Haptics.success()
            let message = Vocabulary.praise.randomElement() ?? "¡Muy bien!"
            Speaker.shared.say(message)
            celebration += 1
            withAnimation(.spring(response: 0.35, dampingFraction: 0.55)) {
                praise = message
            }
            Task { @MainActor in
                try? await Task.sleep(for: .seconds(1.2))
                withAnimation(.easeInOut(duration: 0.3)) {
                    praise = nil
                    shakes = [:]
                    session.advance()
                }
                isAdvancing = false
            }
        case .wrong:
            Haptics.miss()
            // Say the word they picked, so a miss still teaches something.
            Speaker.shared.say(word.spanish)
            withAnimation(.linear(duration: 0.4)) {
                shakes[word.id, default: 0] += 1
            }
        }
    }

    private func restart() {
        withAnimation {
            session = QuizSession(topic: topic)
            shakes = [:]
            praise = nil
            isAdvancing = false
        }
    }
}

/// Side-to-side wiggle for wrong answers.
struct Shake: GeometryEffect {
    var travel: CGFloat = 10
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: travel * sin(animatableData * .pi * 4), y: 0))
    }
}
