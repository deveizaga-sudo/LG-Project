import Foundation
import Observation

/// Best star score per topic, saved on the device only.
@Observable
final class ProgressStore {
    private static let key = "starsByTopic"

    private(set) var starsByTopic: [String: Int]
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.starsByTopic = defaults.dictionary(forKey: Self.key) as? [String: Int] ?? [:]
    }

    var totalStars: Int {
        starsByTopic.values.reduce(0, +)
    }

    func stars(for topic: Topic) -> Int {
        starsByTopic[topic.id] ?? 0
    }

    /// Keeps the best result, so a weaker replay never loses stars.
    func record(_ stars: Int, for topic: Topic) {
        guard stars > self.stars(for: topic) else { return }
        starsByTopic[topic.id] = stars
        defaults.set(starsByTopic, forKey: Self.key)
    }
}
