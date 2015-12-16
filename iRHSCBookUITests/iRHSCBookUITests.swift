//
//  iRHSCBookUITests.swift
//  iRHSCBookUITests
//
//  Created by Bruce Hunter on 2015-12-11.
//  Copyright © 2015 Bruce Hunter. All rights reserved.
//

import XCTest

extension XCUIElement {
    
    func scrollToElement(element: XCUIElement) {
        while !element.visible() {
            swipeUp()
        }
    }
    
    func visible() -> Bool {
        guard self.exists && !CGRectIsEmpty(self.frame) else { return false }
        return CGRectContainsRect(XCUIApplication().windows.elementBoundByIndex(0).frame, self.frame)
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
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Failed to find matching element please file bug (bugreport.apple.com) and provide output from Console.app

        // Failed to find matching element please file bug (bugreport.apple.com) and provide output from Console.app
        
        let app = XCUIApplication()
        app.launch()
        sleep(5)
        let tb = app.tables.matchingIdentifier("CourtTimes")
        let tbc = tb.cells.matchingIdentifier("Court 2 - 10:20 PM")
        
        print(tbc.elementBoundByIndex(0).debugDescription)
        
        app.scrollToElement(tbc.elementBoundByIndex(0))
        tbc.elementBoundByIndex(0).tap()
        
        print("done")
    }
    
}
