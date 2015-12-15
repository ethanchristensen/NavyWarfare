//
//  NavyWarfareTests.swift
//  NavyWarfareTests
//
//  Created by Ethan Christensen on 11/4/15.
//  Copyright © 2015 Ethan Christensen. All rights reserved.
//

import XCTest
@testable import NavyWarfare

class LeaderboardTableViewControllerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let leader = LeaderboardTableViewController()
        leader.viewDidLoad()
        leader.viewDidAppear(true)
        XCTAssertEqual(leader.playerList.count, 5)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
