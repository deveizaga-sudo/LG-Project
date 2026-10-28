import XCTest

/// Plays through the app the way a child would and saves a screenshot of
/// each screen. In CI the PNGs land in $SCREENSHOT_DIR (set through the
/// TEST_RUNNER_SCREENSHOT_DIR variable) and are uploaded as an artifact.
final class PlayThroughUITests: XCTestCase {
    private var app: XCUIApplication!

    @MainActor
    func testLearnAndPlayAFullRound() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()

        snapshot("01-home")

        let animals = app.buttons["topic-animals"]
        XCTAssertTrue(animals.waitForExistence(timeout: 10), "Animals topic card not found")
        animals.tap()

        let learn = app.buttons["mode-learn"]
        XCTAssertTrue(learn.waitForExistence(timeout: 5))
        snapshot("02-topic")

        // Learn: flashcards
        learn.tap()
        let firstCard = element(withIdentifierPrefix: "flashcard-")
        XCTAssertTrue(firstCard.waitForExistence(timeout: 5), "No flashcard shown")
        snapshot("03-flashcard")
        app.swipeLeft()
        sleep(1)
        snapshot("04-flashcard-next")
        app.navigationBars.buttons.element(boundBy: 0).tap()

        // Play: one round of questions
        let play = app.buttons["mode-play"]
        XCTAssertTrue(play.waitForExistence(timeout: 5))
        play.tap()

        var answered = 0
        while answered < 20 {
            let prompt = element(withIdentifierPrefix: "prompt-")
            if !prompt.waitForExistence(timeout: 5) { break }
            let answerID = String(prompt.identifier.dropFirst("prompt-".count))

            if answered == 0 {
                snapshot("05-question-hear")
                // Show what a wrong answer looks like once.
                let wrong = element(withIdentifierPrefix: "choice-", excluding: "choice-\(answerID)")
                if wrong.exists {
                    wrong.tap()
                    snapshot("06-wrong-answer")
                }
            }
            if answered == 1 {
                snapshot("07-question-see")
            }

            let right = app.descendants(matching: .any)["choice-\(answerID)"]
            XCTAssertTrue(right.waitForExistence(timeout: 5), "Correct choice \(answerID) not found")
            right.tap()
            if answered == 0 {
                snapshot("08-correct-reward")
            }
            answered += 1

            // Wait for the next question (or the results) to replace this one.
            let stale = app.descendants(matching: .any)["prompt-\(answerID)"]
            let gone = XCTNSPredicateExpectation(predicate: NSPredicate(format: "exists == false"), object: stale)
            _ = XCTWaiter.wait(for: [gone], timeout: 5)
            if app.staticTexts["result-title"].exists { break }
        }

        XCTAssertTrue(app.staticTexts["result-title"].waitForExistence(timeout: 10), "Results screen not shown")
        sleep(2) // let the stars animate in
        snapshot("09-results")

        // Back home: the topic card should now show its stars.
        app.buttons["Volver"].tap()
        app.navigationBars.buttons.element(boundBy: 0).tap()
        XCTAssertTrue(animals.waitForExistence(timeout: 5))
        snapshot("10-home-with-stars")
    }

    // MARK: - Helpers

    @MainActor
    private func element(withIdentifierPrefix prefix: String, excluding excluded: String? = nil) -> XCUIElement {
        var format = "identifier BEGINSWITH %@"
        var args: [Any] = [prefix]
        if let excluded {
            format += " AND identifier != %@"
            args.append(excluded)
        }
        return app.descendants(matching: .any)
            .matching(NSPredicate(format: format, argumentArray: args))
            .firstMatch
    }

    @MainActor
    private func snapshot(_ name: String) {
        let screenshot = XCUIScreen.main.screenshot()

        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)

        if let dir = ProcessInfo.processInfo.environment["SCREENSHOT_DIR"], !dir.isEmpty {
            let folder = URL(fileURLWithPath: dir, isDirectory: true)
            try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
            try? screenshot.pngRepresentation.write(to: folder.appendingPathComponent("\(name).png"))
        }
    }
}
