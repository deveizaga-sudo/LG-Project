import SwiftUI

enum Theme {
    static let background = Color(red: 1.0, green: 0.976, blue: 0.93)
    static let ink = Color(red: 0.16, green: 0.14, blue: 0.24)
    static let inkSoft = Color(red: 0.42, green: 0.40, blue: 0.50)
    static let accent = Color(red: 1.0, green: 0.478, blue: 0.235)
    static let gold = Color(red: 1.0, green: 0.76, blue: 0.1)
    static let success = Color(red: 0.2, green: 0.72, blue: 0.4)

    static func title(_ size: CGFloat) -> Font {
        .system(size: size, weight: .heavy, design: .rounded)
    }

    static func body(_ size: CGFloat) -> Font {
        .system(size: size, weight: .semibold, design: .rounded)
    }
}

extension Topic {
    var tint: Color { Color(hue: hue, saturation: 0.55, brightness: 0.97) }
    var tintDeep: Color { Color(hue: hue, saturation: 0.75, brightness: 0.75) }
}

/// Big, squishy button style used throughout so every tap feels responsive.
struct BouncyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.93 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

struct StarsView: View {
    let count: Int
    var size: CGFloat = 20

    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<3, id: \.self) { i in
                Image(systemName: i < count ? "star.fill" : "star")
                    .font(.system(size: size, weight: .bold))
                    .foregroundStyle(i < count ? Theme.gold : Theme.inkSoft.opacity(0.35))
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(count) of 3 stars")
    }
}
