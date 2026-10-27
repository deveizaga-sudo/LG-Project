import Foundation
import Observation

struct QuizQuestion: Identifiable {
    enum Kind {
        /// Hear the Spanish word (and see it written), pick the picture.
        case hearWord
        /// See the picture, pick the Spanish word.
        case seePicture
    }

    let id = UUID()
    let answer: Word
    let choices: [Word]
    let kind: Kind
}

enum QuizBuilder {
    static let questionCount = 8
    static let choiceCount = 3

    /// Builds a round that cycles through the topic's words before repeating
    /// any, and alternates between the two question kinds.
    static func questions<G: RandomNumberGenerator>(
        for topic: Topic,
        count: Int = QuizBuilder.questionCount,
        choiceCount: Int = QuizBuilder.choiceCount,
        using rng: inout G
    ) -> [QuizQuestion] {
        guard count > 0, topic.words.count >= choiceCount else { return [] }

        var answers: [Word] = []
        while answers.count < count {
            var batch = topic.words.shuffled(using: &rng)
            // Don't ask the same word twice in a row across a batch boundary.
            if let last = answers.last, batch.first == last, batch.count > 1 {
                batch.swapAt(0, batch.count - 1)
            }
            answers += batch
        }

        var questions: [QuizQuestion] = []
        for (index, answer) in answers.prefix(count).enumerated() {
            let distractors = topic.words
                .filter { $0 != answer }
                .shuffled(using: &rng)
                .prefix(choiceCount - 1)
            let choices = ([answer] + distractors).shuffled(using: &rng)
            let kind: QuizQuestion.Kind = index.isMultiple(of: 2) ? .hearWord : .seePicture
            questions.append(QuizQuestion(answer: answer, choices: choices, kind: kind))
        }
        return questions
    }

    /// Stars are earned from answers right on the first try; finishing
    /// always earns at least one.
    static func stars(firstTryCorrect: Int, total: Int) -> Int {
        guard total > 0 else { return 0 }
        let ratio = Double(firstTryCorrect) / Double(total)
        if ratio >= 0.9 { return 3 }
        if ratio >= 0.6 { return 2 }
        return 1
    }
}

/// State for one round of play. Wrong picks never end the round: the child
/// keeps trying until they find the answer, but only first-try answers count
/// toward the streak and stars.
@Observable
final class QuizSession {
    enum Outcome {
        case correct
        case wrong
    }

    let topic: Topic
    let questions: [QuizQuestion]
    private(set) var index = 0
    private(set) var streak = 0
    private(set) var bestStreak = 0
    private(set) var firstTryCorrect = 0
    private(set) var wrongPicks: Set<String> = []
    private(set) var isFinished = false
    private var missedCurrent = false

    init(topic: Topic, questions: [QuizQuestion]) {
        self.topic = topic
        self.questions = questions
        self.isFinished = questions.isEmpty
    }

    convenience init(topic: Topic) {
        var rng = SystemRandomNumberGenerator()
        self.init(topic: topic, questions: QuizBuilder.questions(for: topic, using: &rng))
    }

    var current: QuizQuestion? {
        index < questions.count ? questions[index] : nil
    }

    var progress: Double {
        questions.isEmpty ? 1 : Double(index) / Double(questions.count)
    }

    var stars: Int {
        QuizBuilder.stars(firstTryCorrect: firstTryCorrect, total: questions.count)
    }

    func pick(_ word: Word) -> Outcome {
        guard let question = current else { return .wrong }
        if word == question.answer {
            if !missedCurrent {
                firstTryCorrect += 1
                streak += 1
                bestStreak = max(bestStreak, streak)
            }
            return .correct
        }
        missedCurrent = true
        streak = 0
        wrongPicks.insert(word.id)
        return .wrong
    }

    func advance() {
        guard !isFinished else { return }
        index += 1
        wrongPicks = []
        missedCurrent = false
        if index >= questions.count {
            isFinished = true
        }
    }
}
