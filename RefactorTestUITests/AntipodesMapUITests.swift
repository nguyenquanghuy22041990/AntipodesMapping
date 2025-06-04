//
//  AntipodesMapUITests.swift
//  RefactorTest
//
//  Created by Huy Quang Nguyen on 6/6/25
//

import XCTest

final class AntipodesMapUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["UI-Testing"]
        app.launch()
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    func test_initialState() {
        let primaryLabel = app.staticTexts["Select a location"]
        XCTAssertTrue(primaryLabel.exists)
        XCTAssertTrue(primaryLabel.isHittable)
    }
    
    func test_mapInteraction() {
        // Given
        let map = app.maps.firstMatch
        XCTAssertTrue(map.exists)
        
        // When - Long press on map
        let coordinate = map.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        coordinate.press(forDuration: 1.0)
        
        // Then - Wait for labels to update
        let expectation = expectation(description: "Wait for location labels to update")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
        
        // Verify that both labels have content
        XCTAssertNotEqual(app.staticTexts.element(boundBy: 0).label, "Select a location")
        XCTAssertFalse(app.staticTexts.element(boundBy: 1).label.isEmpty)
    }
} 
