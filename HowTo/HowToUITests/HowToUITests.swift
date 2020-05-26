//
//  HowToUITests.swift
//  HowToUITests
//
//  Created by Shawn James on 5/22/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import XCTest
@testable import HowTo

class HowToUITests: XCTestCase {

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch the application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func testMenuButtonOpensMenu() {
        // launch application
        let application = XCUIApplication()
        application.launch()
        // check to see if on homeScreen <-- this will fail if it can't get to the screen and test will need to be added to so it can get here.
        XCTAssertEqual(application.navigationBars.element.identifier, "Home")
        // press menu button
        let menuButton = application.buttons["menuButton"]
        XCTAssert(menuButton.exists)
        menuButton.tap()
        // this will test that the menu is opening correctly and also that the items in the menu are being displayed.
        let menuTableViewCells = application.tables.cells.count
        XCTAssertNotEqual(menuTableViewCells, 0)
    }
    
}
