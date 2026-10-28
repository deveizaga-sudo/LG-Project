import XCTest
@testable import HolaAmigos

/// Deterministic random numbers so quiz tests are repeatable.
struct SeededGenerator: RandomNumberGenerator {
    private var state: UInt64

    init(seed: UInt64) { state = seed }

    mutating func next() -> UInt64 {
        state &+= 0x9E37_79B9_7F4A_7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58_476D_1CE4_E5B9
        z = (z ^ (z >> 27)) &* 0x94D0_49BB_1331_11EB
        return z ^ (z >> 31)
    }
}

final class QuizBuilderTests: XCTestCase {
    func testEveryTopicBuildsAFullRoundOfValidQuestions() {
        for topic in Vocabulary.topics {
            for seed in 0..<50 {
                var rng = SeededGenerator(seed: UInt64(seed))
                let questions = QuizBuilder.questions(for: topic, using: &rng)

                XCTAssertEqual(questions.count, QuizBuilder.questionCount, topic.id)
                for (i, question) in questions.enumerated() {
                    XCTAssertEqual(question.choices.count, QuizBuilder.choiceCount, topic.id)
                    XCTAssertEqual(Set(question.choices).count, question.choices.count, "duplicate choice in \(topic.id)")
                    XCTAssertTrue(question.choices.contains(question.answer), topic.id)
                    XCTAssertTrue(question.choices.allSatisfy { topic.words.contains($0) }, topic.id)
                    XCTAssertEqual(question.kind, i.isMultiple(of: 2) ? .hearWord : .seePicture)
                }
                for (a, b) in zip(questions, questions.dropFirst()) {
                    XCTAssertNotEqual(a.answer, b.answer, "same word twice in a row in \(topic.id)")
                }
            }
        }
    }

    func testRoundUsesEveryWordBeforeRepeating() {
        let topic = Vocabulary.topics.first(where: { $0.words.count < QuizBuilder.questionCount })!
        var rng = SeededGenerator(seed: 7)
        let answers = QuizBuilder.questions(for: topic, using: &rng).map(\.answer)
        XCTAssertEqual(Set(answers.prefix(topic.words.count)).count, topic.words.count)
    }

    func testTooFewWordsGivesNoQuestions() {
        let tiny = Topic(id: "tiny", title: "", subtitle: "", emoji: "", hue: 0, words: [
            Word(spanish: "sí", english: "yes", emoji: "👍"),
            Word(spanish: "no", english: "no", emoji: "👎")
        ])
        var rng = SeededGenerator(seed: 1)
        XCTAssertTrue(QuizBuilder.questions(for: tiny, using: &rng).isEmpty)
        XCTAssertTrue(QuizSession(topic: tiny).isFinished)
    }

    func testStarThresholds() {
        XCTAssertEqual(QuizBuilder.stars(firstTryCorrect: 8, total: 8), 3)
        XCTAssertEqual(QuizBuilder.stars(firstTryCorrect: 7, total: 8), 2) // 87.5%
        XCTAssertEqual(QuizBuilder.stars(firstTryCorrect: 5, total: 8), 2) // 62.5%
        XCTAssertEqual(QuizBuilder.stars(firstTryCorrect: 4, total: 8), 1)
        XCTAssertEqual(QuizBuilder.stars(firstTryCorrect: 0, total: 8), 1)
        XCTAssertEqual(QuizBuilder.stars(firstTryCorrect: 0, total: 0), 0)
    }
}

final class QuizSessionTests: XCTestCase {
    private func makeSession(seed: UInt64 = 3) -> QuizSession {
        let topic = Vocabulary.topics[1]
        var rng = SeededGenerator(seed: seed)
        return QuizSession(topic: topic, questions: QuizBuilder.questions(for: topic, using: &rng))
    }

    private func wrongChoice(in session: QuizSession) -> Word {
        let question = session.current!
        return question.choices.first { $0 != question.answer }!
    }

    func testPerfectRoundEarnsThreeStars() {
        let session = makeSession()
        while let question = session.current {
            XCTAssertEqual(session.pick(question.answer), .correct)
            session.advance()
        }
        XCTAssertTrue(session.isFinished)
        XCTAssertEqual(session.firstTryCorrect, QuizBuilder.questionCount)
        XCTAssertEqual(session.bestStreak, QuizBuilder.questionCount)
        XCTAssertEqual(session.stars, 3)
        XCTAssertEqual(session.progress, 1)
    }

    func testWrongPickResetsStreakAndDoesNotCountTheQuestion() {
        let session = makeSession()
        _ = session.pick(session.current!.answer)
        session.advance()
        XCTAssertEqual(session.streak, 1)

        let wrong = wrongChoice(in: session)
        XCTAssertEqual(session.pick(wrong), .wrong)
        XCTAssertEqual(session.streak, 0)
        XCTAssertEqual(session.wrongPicks, [wrong.id])

        // Finding the answer afterwards moves on but earns no first-try credit.
        XCTAssertEqual(session.pick(session.current!.answer), .correct)
        XCTAssertEqual(session.firstTryCorrect, 1)
        XCTAssertEqual(session.streak, 0)

        session.advance()
        XCTAssertTrue(session.wrongPicks.isEmpty)
        XCTAssertEqual(session.bestStreak, 1)
    }

    func testAdvancePastTheEndIsSafe() {
        let session = makeSession()
        for _ in 0..<(QuizBuilder.questionCount + 3) {
            session.advance()
        }
        XCTAssertTrue(session.isFinished)
        XCTAssertNil(session.current)
        XCTAssertEqual(session.index, QuizBuilder.questionCount)
    }
}

final class VocabularyTests: XCTestCase {
    func testTopicsAreUsable() {
        XCTAssertEqual(Set(Vocabulary.topics.map(\.id)).count, Vocabulary.topics.count, "duplicate topic id")
        for topic in Vocabulary.topics {
            XCTAssertGreaterThanOrEqual(topic.words.count, QuizBuilder.choiceCount, topic.id)
            XCTAssertEqual(Set(topic.words.map(\.id)).count, topic.words.count, "duplicate word in \(topic.id)")
            XCTAssertEqual(Set(topic.words.map(\.emoji)).count, topic.words.count, "duplicate picture in \(topic.id)")
            XCTAssertEqual(Set(topic.words.map(\.english)).count, topic.words.count, "duplicate meaning in \(topic.id)")
        }
    }
}

final class ProgressStoreTests: XCTestCase {
    private var defaults: UserDefaults!
    private let suite = "ProgressStoreTests"

    override func setUp() {
        super.setUp()
        defaults = UserDefaults(suiteName: suite)
        defaults.removePersistentDomain(forName: suite)
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: suite)
        super.tearDown()
    }

    func testKeepsBestScoreAndPersists() {
        let animals = Vocabulary.topics[1]
        let colors = Vocabulary.topics[0]
        let store = ProgressStore(defaults: defaults)
        XCTAssertEqual(store.stars(for: animals), 0)

        store.record(2, for: animals)
        store.record(1, for: animals)   // a weaker replay never loses stars
        store.record(3, for: colors)
        XCTAssertEqual(store.stars(for: animals), 2)
        XCTAssertEqual(store.totalStars, 5)

        let reopened = ProgressStore(defaults: defaults)
        XCTAssertEqual(reopened.stars(for: animals), 2)
        XCTAssertEqual(reopened.stars(for: colors), 3)
    }
}
