//
//  Day19Tests.swift
//  
//
//  Created by Chelsey Baker on 10/22/22.
//

import Foundation
import XCTest
@testable import AdventOfCode

class Day19Tests: XCTestCase {
  var day: Day19!
  
  override func setUp() {
    day = Day19()
  }
  
  func test_rotations() {
    let coordinate = Coordinate(x: 1, y: 2, z: 3)
    let allRotations = rotations.map({ $0(coordinate) }).unique()
    XCTAssertEqual(allRotations.count, 24)
  }
  
  func test_part1_practice() {
    let count = try! day.calculatePart1(inputString: Day19Input.Practice)
    XCTAssertEqual(count, 79)
  }
  
  func test_part1_input() {
    let count = try! day.calculatePart1(inputString: Day19Input.Input)
    XCTAssertEqual(count, 403)
  }
  
  func test_part2_practice() {
    let scanners = day.rotateScanners(inputString: Day19Input.Practice)
    XCTAssertEqual(scanners[0].originalLocation, Coordinate(x: 0, y: 0, z: 0))
    
    let scanner1 = scanners.filter({ $0.name == "scanner 1" }).first!
    XCTAssertNotNil(scanner1)
    XCTAssertEqual(scanner1.originalLocation, Coordinate(x: 68, y: -1246, z: -43))
    // 1105,-1205,1229
    let scanner2 = scanners.filter({ $0.name == "scanner 2" }).first!
    XCTAssertNotNil(scanner2)
    XCTAssertEqual(scanner2.originalLocation, Coordinate(x: 1105, y: -1205, z: 1229))
    
    let scanner3 = scanners.filter({ $0.name == "scanner 3" }).first!
    XCTAssertNotNil(scanner3)
    XCTAssertEqual(scanner3.originalLocation, Coordinate(x: -92, y: -2380, z: -20))
    
    let scanner4 = scanners.filter({ $0.name == "scanner 4" }).first!
    XCTAssertNotNil(scanner4)
    XCTAssertEqual(scanner4.originalLocation, Coordinate(x: -20, y: -1133, z: 1061))
    
    let count = try! day.calculatePart2(inputString: Day19Input.Practice)
    XCTAssertEqual(count, 3621)
  }
  
  func test_part2_input() {
    let count = try! day.calculatePart2(inputString: Day19Input.Input)
    // 7753 is too low
    XCTAssertEqual(count, 10569)
  }
}
