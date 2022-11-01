import Foundation
import Helpers

enum PacketType: Int {
  case Sum = 0
  case Product = 1
  case Minimum = 2
  case Maximum = 3
  case Literal = 4
  case GreaterThan = 5
  case LessThan = 6
  case EqualTo = 7
}

protocol Packet {
  var header: PacketHeader { get }
  var value: Int { get }
}

struct PacketHeader: Equatable {
  let version: Int
  let packetType: PacketType
}

let VersionBitLength = 3
let TypeBitLength = 3

struct LiteralPacket: Packet {
  let header: PacketHeader
  let value: Int
}

protocol OperatorPacket: Packet {
  var subpackets: [Packet] { get }
}

struct Operator15Packet: OperatorPacket {
  let header: PacketHeader
  let value: Int
  let subpackets: [Packet]
}

struct Operator11Packet: OperatorPacket {
  let header: PacketHeader
  let value: Int
  let subpackets: [Packet]
}

class Day16: AoCPrintable {
  let day = 16
  let input = Day16Input.Input
  
  func calculatePart1(inputString: String) throws -> Int {
    var binaryArray = try inputString.convertHexToBinary()
    let packet = try parsePacket(bitString: &binaryArray)
    let sumVersion = try sumVersions(packet: packet)
    return sumVersion
  }
  
  func calculatePart2(inputString: String) throws -> Int {
    var binaryArray = try inputString.convertHexToBinary()
    let packet = try parsePacket(bitString: &binaryArray)
    let value = try calculatePacketValue(packet: packet)
    return value
  }
  
  func parsePacket(bitString: inout String) throws -> Packet {
    let header = try parsePacketHeader(bitString: &bitString)
    
    if (header.packetType == PacketType.Literal) {
      return try parseLiteralPacket(header: header, bitString: &bitString)
    } else {
      return try parseOperatorPacket(header: header, bitString: &bitString)
    }
  }
  
  func parseOperatorPacket(header: PacketHeader, bitString: inout String) throws -> OperatorPacket {
    guard (header.packetType != PacketType.Literal) else {
      throw AoCError.GeneralError("Parsing an operator packet that is not an operator")
    }
    
    let lengthTypeId = try bitString.pop(1)
    if (lengthTypeId == "0") {
      return try parseOperatorPacket15(header: header, lengthTypeId: lengthTypeId, bitString: &bitString)
    } else {
      return try parseOperatorPacket11(header: header, lengthTypeId: lengthTypeId, bitString: &bitString)
    }
    
  }
  
  func parseLiteralPacket(header: PacketHeader, bitString: inout String) throws -> LiteralPacket {
    
    guard (header.packetType == PacketType.Literal) else {
      throw AoCError.GeneralError("Parsing a literal packet that is not literal")
    }
    var stillBitsToParse = true
    
    var packetBits = ""
    
    while (stillBitsToParse) {
      var newBits = try bitString.pop(5)
      let firstBit = try newBits.pop(1)
      if (firstBit == "0") { stillBitsToParse = false }
      packetBits += newBits
    }
    
    let value = try packetBits.convertBinaryToInt()
    
    return LiteralPacket(header: header, value: value)
  }
  
  func parseOperatorPacket15(header: PacketHeader, lengthTypeId: String, bitString: inout String) throws -> Operator15Packet {
    
    guard (header.packetType != PacketType.Literal) else {
      throw AoCError.GeneralError("Parsing an operator packet that is not an operator")
    }
    
    guard (lengthTypeId == "0") else {
      throw AoCError.GeneralError("Parsing an Operator 11 packet that is supposed to be 15")
    }
    
    var lengthOfSubpacketBits = try bitString.pop(15).convertBinaryToInt()
    var subpackets: [Packet] = []
    
    while (lengthOfSubpacketBits > 0) {
      let currentLength = bitString.count
      let packet = try parsePacket(bitString: &bitString)
      subpackets.append(packet)
      lengthOfSubpacketBits = lengthOfSubpacketBits - (currentLength - bitString.count)
    }
    
    let value = try calculateValuesFromType(packetType: header.packetType, subpackets: subpackets)
    return Operator15Packet(header: header, value: value, subpackets: subpackets)
  }
  
  func parseOperatorPacket11(header: PacketHeader, lengthTypeId: String, bitString: inout String) throws -> Operator11Packet {
    
    guard (header.packetType != PacketType.Literal) else {
      throw AoCError.GeneralError("Parsing an operator packet that is not an operator")
    }
    
    guard (lengthTypeId == "1") else {
      throw AoCError.GeneralError("Parsing an Operator 15 packet that is supposed to be 11")
    }
    
    let subpacketCount = try bitString.pop(11).convertBinaryToInt()
    var subpackets: [Packet] = []
    
    for _ in 0..<subpacketCount {
      let packet = try parsePacket(bitString: &bitString)
      subpackets.append(packet)
    }
    
    let value = try calculateValuesFromType(packetType: header.packetType, subpackets: subpackets)
    return Operator11Packet(header: header, value: value, subpackets: subpackets)
  }
  
  func parsePacketHeader(bitString: inout String) throws -> PacketHeader {
    let versionBit = try bitString.pop(VersionBitLength)
    let typeBit = try bitString.pop(TypeBitLength)
    
    let version = try versionBit.convertBinaryToInt()
    let type = try typeBit.convertBinaryToInt()
    return PacketHeader(version: version, packetType: PacketType(rawValue: type)!)
  }
  
  func sumVersions(packet: Packet) throws -> Int {
    if let packet = packet as? LiteralPacket { return packet.header.version }
    
    guard let packet = packet as? OperatorPacket else {
      throw AoCError.GeneralError("Invalid packet type")
    }
    
    
    var sum = 0
    try packet.subpackets.forEach { subpacket in
      sum += try sumVersions(packet: subpacket)
    }
    
    return packet.header.version + sum
    
  }
  
  func calculatePacketValue(packet: Packet) throws -> Int {
    if let packet = packet as? LiteralPacket {
      return packet.value
    }
    
    guard let packet = packet as? OperatorPacket else {
      throw AoCError.GeneralError("Invalid packet type")
    }
    
    return try calculateValuesFromType(packetType: packet.header.packetType, subpackets: packet.subpackets)
    
  }
  
  func calculateValuesFromType(packetType: PacketType, subpackets: [Packet]) throws -> Int {
    let subpacketValues = subpackets.map({ $0.value })
    
    switch packetType {
    case .Sum: return subpacketValues.reduce(0, +)
    case .Product: return subpacketValues.reduce(1, *)
    case .Minimum: return subpacketValues.min()!
    case .Maximum: return subpacketValues.max()!
    case .GreaterThan: return subpacketValues[0] > subpacketValues[1] ? 1 : 0
    case .LessThan: return subpacketValues[0] < subpacketValues[1] ? 1 : 0
    case .EqualTo: return subpacketValues[0] == subpacketValues[1] ? 1 : 0
    default: throw AoCError.GeneralError("Packet Type Incorrect")
    }
  }
}

fileprivate let HexDictionary = [
  "0": "0000",
  "1": "0001",
  "2": "0010",
  "3": "0011",
  "4": "0100",
  "5": "0101",
  "6": "0110",
  "7": "0111",
  "8": "1000",
  "9": "1001",
  "A": "1010",
  "B": "1011",
  "C": "1100",
  "D": "1101",
  "E": "1110",
  "F": "1111"
]

extension String {
  func convertHexToBinary() throws -> String {
    var binaryString = ""
    self.forEach({ binaryString = binaryString + HexDictionary[String($0)]! })
    return binaryString
  }
  
  /// Pops the amount from the string.
  mutating func pop(_ count: Int) throws -> String {
    if (count > self.count) {
      throw AoCError.GeneralError("Not enough left in array")
    }
    
    let poppedAmount = self[...(count - 1)]
    self = String(self[count...])
    return String(poppedAmount)
  }
}
