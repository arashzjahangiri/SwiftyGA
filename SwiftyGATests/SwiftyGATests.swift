//
//  SwiftyGATests.swift
//  SwiftyGATests
//
//  Created by Arash Z.Jahangiri on 10/25/17.
//  Copyright © 2017 Arash Z.Jahangiri. All rights reserved.
//

import XCTest
@testable import SwiftyGA

class SwiftyGATests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEvent() {
        let event1 = Event(category: Track.Category.tap, action: Track.Action.back, label: "", value: nil)
        XCTAssertEqual(event1.category.rawValue, "tap")
        XCTAssertEqual(event1.action.rawValue, "back Action")
        XCTAssertEqual(event1.label, "")
        XCTAssertEqual(event1.value, nil)
        
        let event2 = Event(category: Track.Category.click, action: Track.Action.next, label: "test", value: 100)
        XCTAssertEqual(event2.category.rawValue, "click")
        XCTAssertEqual(event2.action.rawValue, "next Action")
        XCTAssertEqual(event2.label, "test")
        XCTAssertEqual(event2.value, 100)
        
        let event3 = Event(category: Track.Category.click, action: Track.Action.tap, label: "event 3", value: 19)
        XCTAssertEqual(event3.category.rawValue, "click")
        XCTAssertEqual(event3.action.rawValue, "tap Action")
        XCTAssertEqual(event3.label, "event 3")
        XCTAssertEqual(event3.value, 19)
        
    }
    
    func testSession() {
        let session1 = SessionStart(description: "starting session")
        XCTAssertEqual(session1.description, "starting session")
        
        let session2 = SessionEnd(description: "ending session")
        XCTAssertEqual(session2.description, "ending session")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
