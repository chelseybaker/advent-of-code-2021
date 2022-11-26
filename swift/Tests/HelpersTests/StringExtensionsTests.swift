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
  
  
  func test_pop() {
    var myString = "12345"
    var popped = myString.pop()
    XCTAssertEqual(popped, "5")
    XCTAssertEqual(myString, "1234")
    
    myString = "12345"
    popped = myString.pop(fromFront: true)
    XCTAssertEqual(popped, "1")
    XCTAssertEqual(myString, "2345")
  }

}
