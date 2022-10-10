//
//  Day01Calculations.swift
//  AdventOfCode2021Tests
//
//

import XCTest
@testable import AdventOfCode

class Day01CalculationsTests: XCTestCase {

  func testPart1_Practice() {
    let answer = try? Day01().calculatePart1(inputString: Day01Input.Practice)
    XCTAssertEqual(7, answer)
  }
  
  func testPart1_Actual() {
    let answer = try? Day01().calculatePart1(inputString: Day01Input.Input)
    XCTAssertEqual(1462, answer)
  }
  
  func testPart2_Practice() {
    let answer = try? Day01().calculatePart2(inputString: Day01Input.Practice)
    XCTAssertEqual(5, answer)
  }
  
  func testPart2_Actual() {
    let answer = try? Day01().calculatePart2(inputString: Day01Input.Input)
    XCTAssertEqual(1497, answer)
  }
  
}
