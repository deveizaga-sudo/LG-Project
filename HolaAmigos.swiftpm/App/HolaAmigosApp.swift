import SwiftUI

@main
struct HolaAmigosApp: App {
    @State private var progress = ProgressStore()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(progress)
                .preferredColorScheme(.light)
        }
    }
}
