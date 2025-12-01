import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {
    
    func testMainScreen() throws {
        let trackerVC = TrackersViewController()

        assertSnapshot(of: trackerVC, as: .image, record: false)
    }
    
    func testMainScreenInLightTheme() throws {
        let trackerVC = TrackersViewController()

        assertSnapshot(of: trackerVC, as: .image(traits: .init(userInterfaceStyle: .light)), record: false)
    }
    
    func testMainScreenInDarkTheme() throws {
        let trackerVC = TrackersViewController()

        assertSnapshot(of: trackerVC, as: .image(traits: .init(userInterfaceStyle: .dark)), record: false)
    }
}
