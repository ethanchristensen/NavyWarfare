//
//  NavyWarfareUITests.swift
//  NavyWarfareUITests
//
//  Created by Ethan Christensen on 11/4/15.
//  Copyright © 2015 Ethan Christensen. All rights reserved.
//

import XCTest

class NavyWarfareUITests: XCTestCase {
        
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
    }
    // helper function that lets us modify the startup args.
    private func launchAppWithArgs(args: [String]) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = args
        app.launch()
        return app
    }
    
    func testTableLoads() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCUIDevice.sharedDevice().orientation = .Portrait
        
        let app = launchAppWithArgs([ "UI_TESTING_MODE" ])
        
        // check if we have one table
        XCTAssertEqual(app.tables.count, 0)
        
        // confirm we have five rows in the table
        XCTAssertEqual(app.tables.element.cells.count, 0)
        
        XCUIDevice.sharedDevice().orientation = .Portrait
        
    }
    
}
