import SwiftUI

/// A quick burst of emoji confetti whenever `trigger` changes.
struct ConfettiBurst: View {
    let trigger: Int

    private struct Piece: Identifiable {
        let id = UUID()
        let emoji: String
        let dx: CGFloat
        let dy: CGFloat
        let spin: Double
    }

    private static let emojis = ["⭐️", "🎉", "✨", "🌟", "🎈", "💛"]

    @State private var pieces: [Piece] = []
    @State private var flying = false

    var body: some View {
        ZStack {
            ForEach(pieces) { piece in
                Text(piece.emoji)
                    .font(.system(size: 34))
                    .offset(x: flying ? piece.dx : 0, y: flying ? piece.dy : 0)
                    .rotationEffect(.degrees(flying ? piece.spin : 0))
                    .opacity(flying ? 0 : 1)
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
        .onChange(of: trigger) {
            flying = false
            pieces = (0..<18).map { _ in
                Piece(
                    emoji: Self.emojis.randomElement() ?? "⭐️",
                    dx: .random(in: -180...180),
                    dy: .random(in: -300 ... -60),
                    spin: .random(in: -240...240)
                )
            }
            // Start the animation on the next frame so the new pieces are
            // on screen at their starting point first.
            DispatchQueue.main.async {
                withAnimation(.easeOut(duration: 1.0)) {
                    flying = true
                }
            }
        }
    }
}
