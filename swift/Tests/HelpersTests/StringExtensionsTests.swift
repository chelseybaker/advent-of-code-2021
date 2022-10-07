import Foundation
import XCTest
import Helpers

class StringExtensionsTests: XCTestCase {
  func testLineByLine() {
    let testString = """
one
two
three
"""
    
    let lineByLine = testString.asLineByLineArray()
    XCTAssertEqual(["one", "two", "three"], lineByLine)
  }
}
