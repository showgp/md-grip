import XCTest

/// First-use guidance at its consumer seam: an isolated, disposable
/// UserDefaults suite, so the real user domain is never read or written. The
/// guidance must appear automatically once at first launch, stay silent on
/// later launches until the user reopens it, and keep its state separate from
/// the recent targets and unrelated stored data.
final class FirstUseGuidanceStoreTests: XCTestCase {
    private var suiteName: String!
    private var defaults: UserDefaults!

    override func setUpWithError() throws {
        suiteName = "mdgrip-guidance-tests-\(UUID().uuidString)"
        defaults = try XCTUnwrap(UserDefaults(suiteName: suiteName))
    }

    override func tearDownWithError() throws {
        defaults.removePersistentDomain(forName: suiteName)
        defaults = nil
        suiteName = nil
    }

    func testFirstLaunchPresentsOnceAndLaterLaunchesDoNot() {
        let store = FirstUseGuidanceStore(defaults: defaults)

        XCTAssertTrue(store.shouldPresent(), "a fresh install must see the first-use guidance")
        store.markPresented()
        XCTAssertFalse(store.shouldPresent(), "after the guidance was shown it must not present again")
        XCTAssertFalse(
            FirstUseGuidanceStore(defaults: defaults).shouldPresent(),
            "a later launch must keep reading the persisted decision"
        )
    }

    func testGuidanceStateIsSeparateFromRecentAndUnrelatedData() {
        let recents = RecentTargetsStore(defaults: defaults)
        recents.record(identity: "/targets/a", displayPath: "/selected/a", mode: .directory)
        defaults.set(Data("unrelated".utf8), forKey: "unrelated-preference")

        let store = FirstUseGuidanceStore(defaults: defaults)

        XCTAssertTrue(
            store.shouldPresent(),
            "existing legacy or recent records must not be mistaken for an already-shown guidance"
        )
        store.markPresented()

        XCTAssertEqual(recents.load().map(\.identity), ["/targets/a"], "the recent targets must keep their exact record")
        XCTAssertEqual(
            defaults.data(forKey: "unrelated-preference"),
            Data("unrelated".utf8),
            "the guidance state must not touch unrelated stored data"
        )
    }
}
