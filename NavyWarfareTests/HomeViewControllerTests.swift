//
//  NavyWarfareTests.swift
//  NavyWarfareTests
//
//  Created by Ethan Christensen on 11/4/15.
//  Copyright © 2015 Ethan Christensen. All rights reserved.
//
//  iOS Semester Project 2015.  ETHAN CHRISTENSEN & GERAD WEGENER


import XCTest
@testable import NavyWarfare

class HomeViewControllerTests: XCTestCase {
    var viewController: HomeViewController!

    class MockAvailableGamesTableViewController : AvailableGamesTableViewController {}
    
    override func setUp() {
        super.setUp()
        viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testViewDidLoad(){
        
        XCTAssertNotNil(self.viewController.title)
    }
    
}
