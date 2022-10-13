import Foundation
import XCTest
@testable import AdventOfCode

class Day17Tests: XCTestCase {
  var day: Day17!
  
  override func setUp() {
    super.setUp()
    day = Day17()
  }

  
  func test_getTargetArea() {
    let targetArea = try! day.getTargetAreaFromInput(Day17Input.Practice)
    XCTAssertEqual(targetArea.x.min, 20)
    XCTAssertEqual(targetArea.x.max, 30)
    XCTAssertEqual(targetArea.y.min, -10)
    XCTAssertEqual(targetArea.y.max, -5)
  }

  func test_calculatePart1_practice() {
    let example1 = try? day.calculatePart1(inputString: "target area: x=20..30, y=-10..-5")
    XCTAssertEqual(example1, 45)
  }
  
  func test_calculatePart1_Input() {
    let example1 = try? day.calculatePart1(inputString: Day17Input.Input)
    XCTAssertEqual(example1, 2278)
  }
  
  // When X stops moving, Y can continue.
  // The limit is when the delta at y = 0 is greater than the y.min
  
  func test_calculateHighestY() {
    let highestY = day.calculateHighestYWithoutX(for: Range(min: -10, max: -5))
    
    XCTAssertEqual(highestY, 45)
  }
  
  func test_calculateXPositionAtTime() {
    XCTAssertEqual(1, day.calculateXPositionAtTime(time: 6, velocity: 1))
    XCTAssertEqual(3, day.calculateXPositionAtTime(time: 6, velocity: 2))
    XCTAssertEqual(6, day.calculateXPositionAtTime(time: 6, velocity: 3))
    
    XCTAssertEqual(21, day.calculateXPositionAtTime(time: 6, velocity: 6))
    XCTAssertEqual(27, day.calculateXPositionAtTime(time: 6, velocity: 7))
    
    XCTAssertEqual(33, day.calculateXPositionAtTime(time: 6, velocity: 8))
  }
  
  func test_calculatePart2_Practice() {
    let answer = try? day.calculatePart2(inputString: Day17Input.Practice)
    XCTAssertEqual(answer, 112)
  }
  
  func test_calculatePart2_Input() {
    let answer = try? day.calculatePart2(inputString: Day17Input.Input)
    XCTAssertEqual(answer, 996)
  }
}
