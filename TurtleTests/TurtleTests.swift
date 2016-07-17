//
//  TurtleTests.swift
//  TurtleTests
//
//  Created by Joe Wingbermuehle on 6/29/16.
//  Copyright © 2016 Joe Wingbermuehle. All rights reserved.
//

import XCTest
@testable import Turtle

class TurtleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testLoadPlayer() {
        let level = Level(id: 1)
        let (px, py) = level.findPlayer()
        XCTAssert(px > 0)
        XCTAssert(py > 0)
    }

    func testLoadAgents() {
        let level = Level(id: 1)
        let agents = level.getAgents()
        XCTAssert(agents.count > 0)
    }

    func testIsWall() {
        XCTAssert(Level.isWall(Cell.brick))
        XCTAssert(!Level.isWall(Cell.space))
    }

    func testLevelGetSet() {
        let level = Level(id: 1)
        level.set(1, 2, Cell.brick)
        level.set(2, 1, Cell.space)
        XCTAssert(level.get(1, 2) == Cell.brick)
        XCTAssert(level.get(2, 1) == Cell.space)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
