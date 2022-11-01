//
//  File.swift
//  
//
//  Created by Chelsey Baker on 11/1/22.
//

import Foundation
import XCTest
@testable import AdventOfCode

class Day20Tests: XCTestCase {
  var dayPractice: Day20!
  
  override func setUp() {
    super.setUp()
    dayPractice = try! Day20(input: Day20Input.Practice)
  }
  
  func test_calculatePart1Practice() {
    let output = try? dayPractice.calculatePart1(inputString: Day20Input.Practice)
    XCTAssertEqual(output, 35)
  }
  
  func test_calculatePart1Input() {
    dayPractice = try! Day20(input: Day20Input.Input)
    let output = try? dayPractice.calculatePart1(inputString: Day20Input.Input)
    XCTAssertEqual(output, 5359)
  }
  
  func test_calculatePart2Practice() {
    dayPractice = try! Day20(input: Day20Input.Practice)
    let output = try? dayPractice.calculatePart2(inputString: Day20Input.Practice)
    XCTAssertEqual(output, 3351)
  }
  
  func test_calculatePart2Input() {
    dayPractice = try! Day20(input: Day20Input.Input)
    let output = try? dayPractice.calculatePart2(inputString: Day20Input.Input)
    XCTAssertEqual(output, 12333)
  }
}


let ExpectedPracticeAlgorithm = "..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#"

let ExpectedPracticeImage = [
  "#..#.",
  "#....",
  "##..#",
  "..#..",
  "..###"
]

let ExpectedPaddedImage = [
  "...............",
  "...............",
  "...............",
  "...............",
  "...............",
  ".....#..#......",
  ".....#.........",
  ".....##..#.....",
  ".......#.......",
  ".......###.....",
  "...............",
  "...............",
  "...............",
  "...............",
  "..............."
]

let ExpectedPart1PracticePass1Output = """
.........
..##.##..
.#..#.#..
.##.#..#.
.####..#.
..#..##..
...##..#.
....#.#..
.........
"""

let ExpectedPart1PracticeOutput = """
.............
.............
.........#...
...#..#.#....
..#.#...###..
..#...##.#...
..#.....#.#..
...#.#####...
....#.#####..
.....##.##...
......###....
.............
.............
"""
