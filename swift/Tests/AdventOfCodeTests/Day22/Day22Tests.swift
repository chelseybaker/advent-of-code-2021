//
//  File.swift
//  
//
//  Created by Chelsey Baker on 11/1/22.
//

import Foundation
import XCTest
@testable import AdventOfCode

class Day22Tests: XCTestCase {
  override func setUp() {
    super.setUp()
  }
  
  func test_calculatePart1_Practice1_OneLine() {
    let day = try! Day22(input: "on x=10..12,y=10..12,z=10..12")
    let output = try! day.calculatePart1()
    // Too lowX
    XCTAssertEqual(output, 27)
  }
  
  func test_calculatePart1_Practice1_TwoLines() {
    let input = """
on x=10..12,y=10..12,z=10..12
on x=11..13,y=11..13,z=11..13
"""
    
    let day = try! Day22(input: input)
    let output = try! day.calculatePart1()
    // Too lowX
    XCTAssertEqual(output, 27 + 19)
  }
  
  func test_calculatePart1_Practice1_ThreeLines() {
    let input = """
on x=10..12,y=10..12,z=10..12
on x=11..13,y=11..13,z=11..13
off x=9..11,y=9..11,z=9..11
"""
    
    let day = try! Day22(input: input)
    let output = try! day.calculatePart1()
    XCTAssertEqual(output, 27 + 19 - 8)
  }
  
  func test_calculatePart1_Practice1() {
    let day = try! Day22(input: Day22Input.Practice1)
    let output = try! day.calculatePart1()
    XCTAssertEqual(output, 39)
  }
  
  func test_calculatePart1_Practice2() {
    let day = try! Day22(input: Day22Input.Practice2)
    let output = try! day.calculatePart1()
    XCTAssertEqual(output, 590784)
  }
  
  func test_calculatePart1() {
    let day = try! Day22(input: Day22Input.Input)
    let output = try! day.calculatePart1()
    XCTAssertEqual(output, 647062)
  }
  
  func test_calculatePart2() {
    let day = try! Day22(input: Day22Input.Input)
    let output = try! day.calculatePart2()
    XCTAssertEqual(output, 1319618626668022)
  }
  
  
}



