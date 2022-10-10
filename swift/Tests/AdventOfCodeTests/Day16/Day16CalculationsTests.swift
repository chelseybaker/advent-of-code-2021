import XCTest
@testable import AdventOfCode

class Day16Tests: XCTestCase {
  func test_pop() {
    var array = "1234"
    let popped = try? array.pop(2)
    XCTAssertEqual(popped, "12")
    XCTAssertEqual(array, "34")
    
    let morePopped = try? array.pop(4)
    XCTAssertNil(morePopped)
  }
  
  func test_parsePacketHeader_D2FE28() {
    var binary = "110100101111111000101000"
    let expectedHeader = PacketHeader(version: 6, packetType: PacketType(rawValue: 4)!)

    let actualHeader = try? Day16().parsePacketHeader(bitString: &binary)
    XCTAssertEqual(actualHeader, expectedHeader)
  }
  
  func test_parsePacketheader_38006F45291200() {
    var binary = "00111000000000000110111101000101001010010001001000000000"
    let expectedHeader = PacketHeader(version: 1, packetType: PacketType(rawValue: 6)!)
    
    let actualHeader = try? Day16().parsePacketHeader(bitString: &binary)
    XCTAssertEqual(actualHeader, expectedHeader)
  }
  
  func test_parseLiteral() {
    var binary = "110100101111111000101000"
    let expectedHeader = PacketHeader(version: 6, packetType: PacketType(rawValue: 4)!)
    let literalPacket = try! Day16().parsePacket(bitString: &binary)
    
    XCTAssertEqual(literalPacket.header, expectedHeader)
    XCTAssertEqual(literalPacket.value, 2021)
  }
  
  func test_parseOperator15() {
    var binary = try! "38006F45291200".convertHexToBinary()
    let packet = try? Day16().parsePacket(bitString: &binary)
    
    let expectedHeader = PacketHeader(version: 1, packetType: PacketType(rawValue: 6)!)
    
    guard let packet = packet as? Operator15Packet else {
      XCTFail("Not an operator 15 packet")
      return
    }
    
    XCTAssertEqual(packet.header, expectedHeader)
    XCTAssertEqual(packet.subpackets.count, 2)
    XCTAssertEqual(binary, "0000000")
  }
  
  func test_parseOperator11() {
    var binary = try! "EE00D40C823060".convertHexToBinary()
    let expectedHeader = PacketHeader(version: 7, packetType: PacketType(rawValue: 3)!)
    let packet = try? Day16().parsePacket(bitString: &binary)
    
    guard let packet = packet as? Operator11Packet else {
      XCTFail("Not an operator 11 packet")
      return
    }
    
    XCTAssertEqual(packet.header, expectedHeader)
    XCTAssertEqual(packet.subpackets.count, 3)
    XCTAssertEqual(binary, "00000")
  }
  
  func test_operator_8A004A801A8002F478() {
    var binary = try! "8A004A801A8002F478".convertHexToBinary()
    let packet = try? Day16().parsePacket(bitString: &binary)
    
    guard let packet = packet as? OperatorPacket else {
      XCTFail("Not an operator packet")
      return
    }
    
    XCTAssertEqual(packet.header.version, 4)
    XCTAssertEqual(packet.subpackets.count, 1)
    
    guard let subPacket1 = packet.subpackets[0] as? OperatorPacket else {
      XCTFail()
      return
    }
    
    XCTAssertEqual(subPacket1.header.version, 1)
    XCTAssertEqual(subPacket1.subpackets.count, 1)
    
    guard let subPacket2 = subPacket1.subpackets[0] as? OperatorPacket else {
      XCTFail()
      return
    }
    
    XCTAssertEqual(subPacket2.header.version, 5)
    XCTAssertEqual(subPacket2.subpackets.count, 1)
    
    guard let _ = subPacket2.subpackets[0] as? LiteralPacket else {
      XCTFail()
      return
    }
  }
  
  func test_sumVersions_8A004A801A8002F478() {
    var binary = try! "8A004A801A8002F478".convertHexToBinary()
    let packet = try! Day16().parsePacket(bitString: &binary)
    
    let sum = try! Day16().sumVersions(packet: packet)
    
    XCTAssertEqual(sum, 16)
  }
  
  func test_sumVersions_620080001611562C8802118E34() {
    var binary = try! "620080001611562C8802118E34".convertHexToBinary()
    let packet = try! Day16().parsePacket(bitString: &binary)
    
    let sum = try! Day16().sumVersions(packet: packet)
    
    XCTAssertEqual(sum, 12)
  }
  
  func test_sumVersions_C0015000016115A2E0802F182340() {
    var binary = try! "C0015000016115A2E0802F182340".convertHexToBinary()
    let packet = try! Day16().parsePacket(bitString: &binary)
    
    let sum = try! Day16().sumVersions(packet: packet)
    
    XCTAssertEqual(sum, 23)
  }
  
  func test_sumVersions_A0016C880162017C3686B18A3D4780() {
    var binary = try! "A0016C880162017C3686B18A3D4780".convertHexToBinary()
    let packet = try! Day16().parsePacket(bitString: &binary)
    
    let sum = try! Day16().sumVersions(packet: packet)
    
    XCTAssertEqual(sum, 31)
  }
  
  func test_calculatePart1_Input() {
    let answer = try! Day16().calculatePart1(inputString: Day16Input.Input)
    
    XCTAssertEqual(answer, 999)
  }
  
  func test_calculatePart2_C200B40A82() {
    let answer = try! Day16().calculatePart2(inputString: "C200B40A82")
    XCTAssertEqual(answer, 3)
  }
  
  func test_calculatePart2_04005AC33890() {
    let answer = try! Day16().calculatePart2(inputString: "04005AC33890")
    XCTAssertEqual(answer, 54)
  }
  
  func test_calculatePart2_880086C3E88112() {
    let answer = try! Day16().calculatePart2(inputString: "880086C3E88112")
    XCTAssertEqual(answer, 7)
  }
  
  func test_calculatePart2_CE00C43D881120() {
    let answer = try! Day16().calculatePart2(inputString: "CE00C43D881120")
    XCTAssertEqual(answer, 9)
  }
  
  func test_calculatePart2_D8005AC2A8F0() {
    let answer = try! Day16().calculatePart2(inputString: "D8005AC2A8F0")
    XCTAssertEqual(answer, 1)
  }
  
  func test_calculatePart2_F600BC2D8F() {
    let answer = try! Day16().calculatePart2(inputString: "F600BC2D8F")
    XCTAssertEqual(answer, 0)
  }
  
  func test_calculatePart2_9C005AC2F8F0() {
    let answer = try! Day16().calculatePart2(inputString: "9C005AC2F8F0")
    XCTAssertEqual(answer, 0)
  }
  
  func test_calculatePart2_9C0141080250320F1802104A08() {
    let answer = try! Day16().calculatePart2(inputString: "9C0141080250320F1802104A08")
    XCTAssertEqual(answer, 1)
  }
  
  func test_calculatePart2() {
    let answer = try! Day16().calculatePart2(inputString: Day16Input.Input)
    XCTAssertEqual(answer, 3408662834145)
  }
}
