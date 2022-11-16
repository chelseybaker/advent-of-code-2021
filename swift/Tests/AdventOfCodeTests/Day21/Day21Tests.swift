//
//  File.swift
//  
//
//  Created by Chelsey Baker on 11/1/22.
//

import Foundation
import XCTest
@testable import AdventOfCode

class Day21Tests: XCTestCase {

  
  override func setUp() {
    super.setUp()
  }
  
  func test_calculatePart1_Practice() {
    let day = Day21(input: Day21Input.Practice)
    
    let output = try! day.calculatePart1()
    XCTAssertEqual(output, 590784)
  }
  
  func test_calculatePart1_Input() {
    let day = Day21(input: Day21Input.Input)
    
    let output = try! day.calculatePart1()
    XCTAssertEqual(output, 647062)
  }

  
}
