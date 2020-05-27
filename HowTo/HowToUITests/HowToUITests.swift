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
    
    func testDetailViewOpensForTappedCell() {
        // launch application
        let application = XCUIApplication()
        application.launch()
        // check to see if on homeScreen <-- this will fail if it can't get to the screen and test will need to be added to so it can get here.
        XCTAssertEqual(application.navigationBars.element.identifier, "Home")
        let homeTableViewCellsCount = application.tables.cells.count
        XCTAssertNotEqual(homeTableViewCellsCount, 0)
        // go to detail of first cell
        let firstCell = application.tables.cells.element(boundBy: 0)
        XCTAssert(firstCell.exists)
        firstCell.tap()
        let howToTitleLabel = application.staticTexts["howToTitleLabel"]
        XCTAssert(howToTitleLabel.exists)
    }
    
    func testOnboardingCanBeReturnedToFromMenu() {
        // launch application
        let application = XCUIApplication()
        application.launch()
        // check to see if on homeScreen <-- this will fail if it can't get to the screen and test will need to be added to so it can get here.
        XCTAssertEqual(application.navigationBars.element.identifier, "Home")
        // press menu button
        let menuButton = application.buttons["menuButton"]
        XCTAssert(menuButton.exists)
        menuButton.tap()
        // select the 4th cell, which should be logout, or create account button.
        let menuTableViewCells = application.tables.cells.count
        XCTAssertNotEqual(menuTableViewCells, 0)
        let fourthCell = application.tables.cells.element(boundBy: 3)
        XCTAssert(fourthCell.exists)
        fourthCell.tap()
        // check to see if the onboarding scene has been returned to
        let signInButton = application.buttons["SignUpButton"]
        XCTAssert(signInButton.exists)
    }
    
    // FIXME: - this needs to be watched until it can check itself
    func testMenuOpensAndClosesWithSideSwipeGesture() {
        // launch application
        let application = XCUIApplication()
        application.launch()
        // check to see if on homeScreen <-- this will fail if it can't get to the screen and test will need to be added to so it can get here.
        let navBarTitle = application.navigationBars.element.identifier
        XCTAssertEqual(navBarTitle, "Home")
        // grab first cell
        let firstCell = application.tables.cells.element(boundBy: 0)
        XCTAssert(firstCell.exists)
        // test that swiping opens the menu
        let rightOffset = CGVector(dx: 0.95, dy: 0.5)
        let leftOffset = CGVector(dx: 0.05, dy: 0.5)
        let cellFarRightCoordinate = firstCell.coordinate(withNormalizedOffset: rightOffset)
        let cellFarLeftCoordinate = firstCell.coordinate(withNormalizedOffset: leftOffset)
        cellFarRightCoordinate.press(forDuration: 0.1, thenDragTo: cellFarLeftCoordinate)
//        let firstMenuCell = application.staticTexts["firstMenuCell"]
//        XCTAssert(firstMenuCell.exists)
        cellFarLeftCoordinate.press(forDuration: 0.1, thenDragTo: cellFarRightCoordinate)
    }
    
    // FIXME: - this needs to be watched as there seems to be no way for it to check itself
    func testRefreshControl() {
        // launch app
        let application = XCUIApplication()
        application.launch()
        // verify that we are on the home screen, if this fails, we probly need to rewrite the test to make sure that we are starting here
        let currentNavigationBarTitle = application.navigationBars.element.identifier
        XCTAssertEqual(currentNavigationBarTitle, "Home")
        // grab first & second cell
        let firstCell = application.tables.cells.element(boundBy: 0)
        let secondCell = application.tables.cells.element(boundBy: 1)
        firstCell.press(forDuration: 0.1, thenDragTo: secondCell)
    }
    
}
