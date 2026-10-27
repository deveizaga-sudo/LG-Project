import AVFoundation

/// Reads Spanish aloud with the on-device voice (no network needed).
@MainActor
final class Speaker {
    static let shared = Speaker()

    private let synthesizer = AVSpeechSynthesizer()
    private let voice = AVSpeechSynthesisVoice(language: "es-MX")
        ?? AVSpeechSynthesisVoice(language: "es-ES")

    private init() {
        // Play even when the ring/silent switch is on.
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio)
    }

    func say(_ text: String, slow: Bool = false) {
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = voice
        utterance.rate = slow ? 0.3 : 0.42
        utterance.pitchMultiplier = 1.1
        synthesizer.speak(utterance)
    }
}
