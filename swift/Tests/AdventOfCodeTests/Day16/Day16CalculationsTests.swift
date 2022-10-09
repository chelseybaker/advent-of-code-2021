//
//  Day01Calculations.swift
//  AdventOfCode2021Tests
//
//

import XCTest
@testable import AdventOfCode

class Day16CalculationsTests: XCTestCase {

  let literalPacket1 = "110100101111111000101000"
  
  let operatorPacket15 = "00111000000000000110111101000101001010010001001000000000"
  let operatorPacket11 = "11101110000000001101010000001100100000100011000001100000"
  
  var day: Day16Calculations!
  
  override func setUp() {
    super.setUp()
    day = Day16Calculations()
  }
  
  func test_getVersionAndId() {
    let output1 = try! day.getVersionAndId(binaryString: literalPacket1)
    XCTAssertEqual(output1.version, 6)
    XCTAssertEqual(output1.packetTypeId, 4)
    XCTAssertEqual(output1.restOfBinaryString, "101111111000101000")
    
    let output2 = try! day.getVersionAndId(binaryString: operatorPacket15)
    XCTAssertEqual(output2.version, 1)
    XCTAssertEqual(output2.packetTypeId, 6)
    
    
    let output3 = try! day.getVersionAndId(binaryString: operatorPacket11)
    XCTAssertEqual(output3.version, 7)
    XCTAssertEqual(output3.packetTypeId, 3)
  }
  
  func test_parseLiteralValue() {
    XCTAssertThrowsError(try day.parseLiteralValue(binaryString: operatorPacket15))
    
    XCTAssertThrowsError(try day.parseLiteralValue(binaryString: operatorPacket11))
    
    XCTAssertNoThrow(try day.parseLiteralValue(binaryString: literalPacket1))
    
    
    let output = try! day.parseLiteralValue(binaryString: literalPacket1)
    
    let packet = output.packet
    XCTAssertEqual(packet.version, 6)
    XCTAssertEqual(packet.typeId, 4)
    XCTAssertEqual(packet.value, 2021)
    XCTAssertEqual(packet.wholePacket, "110100101111111000101")
    XCTAssertEqual(output.restOfBinaryString, "000")
  }
  
  func test_parseAs15() {
    let output1 = try! day.parseOperatorValue(binaryString: operatorPacket15)
    let packet = output1.packet as! OperatorPacket15
    XCTAssertEqual(packet.version, 1)
    XCTAssertEqual(packet.typeId, 6)
    XCTAssertEqual(packet.lengthOfSubPackets, 27)
    XCTAssertEqual(packet.wholePacket, "0011100000000000011011110100010100101001000100100")
  }
  
  func test_parseAs11() {
    let output1 = try! day.parseOperatorValue(binaryString: operatorPacket11)
    let packet = output1.packet as! OperatorPacket11
    XCTAssertEqual(packet.version, 7)
    XCTAssertEqual(packet.typeId, 3)
    XCTAssertEqual(packet.numberOfSubPackets, 3)
    XCTAssertEqual(packet.wholePacket, "111011100000000011010100000011001000001000110000011")
    XCTAssertEqual(output1.restOfBinaryString, "00000")
  }
  
  func testUnpackPackets() {
    let binaryString = try! "8A004A801A8002F478".convertHexToBinary()
    let output = try! day.unpackPackets(binaryString: binaryString)
    
  }
  
  func test_calculatePart1_Test() {
    let testHex = "8A004A801A8002F478"
    let testVersionTotal = try! day.calculatePart1(inputString: testHex)
    XCTAssertEqual(testVersionTotal, 16)
  }

  func test_calculatePart1_Input() {
    let versionTotal = try! day.calculatePart1(inputString: Day16.Input)
    XCTAssertEqual(versionTotal, 999)
  }
  
}
