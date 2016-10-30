//
//  iRHSCBookUITests.swift
//  iRHSCBookUITests
//
//  Created by Bruce Hunter on 2015-12-11.
//  Copyright © 2015 Bruce Hunter. All rights reserved.
//

import XCTest

extension XCUIElement {
    
    func scrollToElement(_ element: XCUIElement) {
        while !element.visible() {
            swipeUp()
        }
    }
    
    func visible() -> Bool {
        guard self.exists && !self.frame.isEmpty else { return false }
        return XCUIApplication().windows.element(boundBy: 0).frame.contains(self.frame)
    }
    
}

class iRHSCBookUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNavigateToBookCourt() {
        let app = XCUIApplication()
        let tb = app.tables.matching(identifier: "CourtTimes")
        let tbc = tb.cells.matching(identifier: "Court 2 - 10:20 PM")
        
//        XCTAssert(tbc.elementBoundByIndex(0).exists)
        
        app.scrollToElement(tbc.element(boundBy: 0))
        tbc.element(boundBy: 0).tap()
        
        let navb = XCUIApplication().navigationBars.matching(identifier: "Book Court")
        XCTAssert(navb.element(boundBy: 0).exists)
        
        app.tables.buttons["Player2Val"].tap()
        
        app.sheets.collectionViews.buttons["Member"].tap()

        let tb2 = app.tables.matching(identifier: "FindMember")
        XCTAssert(tb2.element(boundBy: 0).exists)

        let tb2c = tb2.cells.matching(identifier: "Booker, Test \"test\"")
        
        app.scrollToElement(tb2c.element(boundBy: 0))
        tb2c.element(boundBy: 0).tap()
        
        let tb4 = XCUIApplication().navigationBars["Book Court"]
        XCTAssert(tb4.exists)

        tb4.buttons["Confirm"].tap()
        
        sleep(5)
        
        let tb3 = XCUIApplication().tables.matching(identifier: "CourtTimes")
        XCTAssert(tb3.element(boundBy: 0).exists)
        
    }
    
    func testNavigateToCancelCourt() {
        
    }
    
}
