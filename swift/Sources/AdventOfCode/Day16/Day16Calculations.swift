import Foundation
import Helpers

protocol Day16Error {
  var message: String { get }
}

enum Day16CalculationsError: Day16Error, Error {
  case CannotConvertFromBinary(binary: String)
  case CannotConvertToDecimalFromHex(hex: String)
  case GeneralError(_ message: String)
  
  var message: String {
    switch self {
    case .CannotConvertFromBinary(let binary): return "Cannot convert \(binary) to Int"
    case .CannotConvertToDecimalFromHex(let hex): return "Cannot convert \(hex) to Int"
    case .GeneralError(let message): return message
    }
  }
}

protocol Packet {
  var version: Int { get }
  var typeId: Int { get }
  var wholePacket: String { get }// including header
}

struct LiteralPacket: Packet {
  let version: Int
  let typeId: Int
  let wholePacket: String // including header
  let value: Int
}

protocol OperatorPacket: Packet {
  var packets: [Packet] { get }
}

struct OperatorPacket15: OperatorPacket {
  let version: Int
  let typeId: Int
  let wholePacket: String // including header
  let packets: [Packet]
  let lengthOfSubPackets: Int
}

struct OperatorPacket11: OperatorPacket {
  let version: Int
  let typeId: Int
  let wholePacket: String // including header
  let packets: [Packet]
  let numberOfSubPackets: Int
}

// https://adventofcode.com/2021/day/16
class Day16Calculations: DayCalculatable {
  let day: Int = 16
  let input: String = Day16.Input

  
  func calculatePart1(inputString: String) throws -> Int {
    let binaryString = try inputString.convertHexToBinary()
    
    let packets = try unpackPackets(binaryString: binaryString)
    
    print("Total packets: \(packets.count)")
    
    var total = 0
    packets.forEach { packet in
      total += calculateVersions(packet: packet)
    }
    
    return total
  }
  
  func unpackPackets(binaryString: String) throws -> [Packet] {
    var restOfBinaryString = binaryString
    
    var packets: [Packet] = []
    
    while (restOfBinaryString.contains("1")) {
      let versionAndId = try getVersionAndId(binaryString: restOfBinaryString)
      if (versionAndId.packetTypeId == 4) {
        let output = try parseLiteralValue(binaryString: restOfBinaryString)
        packets.append(output.packet)
        restOfBinaryString = output.restOfBinaryString
      } else {
        let output = try parseOperatorValue(binaryString: restOfBinaryString)
        packets.append(output.packet)
        restOfBinaryString = output.restOfBinaryString
      }
    }
    
    return packets
  }
  
  func calculateVersions(packet: Packet) -> Int {
    if let packet = packet as? OperatorPacket {
      var total = 0
      packet.packets.forEach { subpacket in
        total += calculateVersions(packet: subpacket)
      }
      return packet.version + total
    }
    
    return packet.version
  }
  
  func calculatePart2(inputString: String) throws -> Int {
    throw DayCalculatableError.NotYetImplemented
  }
  
  func getVersionAndId(binaryString: String) throws -> (version: Int, packetTypeId: Int, restOfBinaryString: String) {
    if (binaryString.count < 7) {
      throw Day16CalculationsError.GeneralError("Not enough characters in \(binaryString) to determine version and ID")
    }
    
    // version
    let version = try String(binaryString[...2]).convertBinaryToInt()
    let packetTypeId = try String(binaryString[3...5]).convertBinaryToInt()
    
    return (version: version, packetTypeId: packetTypeId, restOfBinaryString: String(binaryString[6...]))
  }
  
  /// Type ID should already be determined to be 4 here
  func parseLiteralValue(binaryString: String) throws -> (packet: LiteralPacket, restOfBinaryString: String) {
    let versionAndId = try getVersionAndId(binaryString: binaryString)
    
    guard (versionAndId.packetTypeId == 4) else {
      throw Day16CalculationsError.GeneralError("Packet is being parsed as literal but type id is \(versionAndId.packetTypeId)")
    }
    
    var wholePacket = String(binaryString[...5])
    
    var restOfBinaryString = versionAndId.restOfBinaryString
    
    var binaryValueString = ""
    var stillParsing = true
    
    while (stillParsing) {
      // Correct
      let bitValues = String(restOfBinaryString[1...4])
      // Correct
      binaryValueString = binaryValueString + bitValues
      
      // Correct?
      if (restOfBinaryString.starts(with: "0")) {
        stillParsing = false
      }
      
      wholePacket += String(restOfBinaryString[...4])
      
      restOfBinaryString = String(restOfBinaryString[5...])
    }
    
    let value = try binaryValueString.convertBinaryToInt()
    let packet = LiteralPacket(version: versionAndId.version,
                               typeId: versionAndId.packetTypeId,
                               wholePacket: wholePacket,
                               value: value)
    
    return (packet: packet, restOfBinaryString: restOfBinaryString)
  }
  
  /// TypeId should not be 4 here
  func parseOperatorValue(binaryString: String) throws -> (packet: OperatorPacket, restOfBinaryString: String) {
    
    let versionAndId = try getVersionAndId(binaryString: binaryString)
    
    guard (versionAndId.packetTypeId != 4) else {
      throw Day16CalculationsError
        .GeneralError("Packet is being parsed as operator but type id is 4")
    }
    

    let binaryBitLength = binaryString[6]
    
    if (binaryBitLength == "0") {
      // Parse as 15 bit
      let output = try parseAsOperator15(binaryString: binaryString)
      return (packet: output.packet, restOfBinaryString: output.restOfBinaryString)
    } else {
      let output = try parseAsOperator11(binaryString: binaryString)
      return (packet: output.packet, restOfBinaryString: output.restOfBinaryString)
    }
  }
  
  // DOES include header or 15/11 number
  func parseAsOperator15(binaryString: String) throws -> (
    packet: OperatorPacket15, restOfBinaryString: String
  ) {
    
    let versionAndId = try getVersionAndId(binaryString: binaryString)
    let lengthOfSubPackets = try String(binaryString[7...21]).convertBinaryToInt()
    
    var wholePacket = String(binaryString[...21]) // Beginnig of packet with version, id, bit type, bit count
    
    var restOfBinaryString = String(binaryString[22...])
    
    var bitCountLeft = lengthOfSubPackets
    
    var subPackets: [Packet] = []
    
    while (bitCountLeft > 0 && restOfBinaryString.contains("1")) {
      let subPacketVersion = try getVersionAndId(binaryString: restOfBinaryString)
      
      if (subPacketVersion.packetTypeId == 4) {
        let output = try parseLiteralValue(binaryString: restOfBinaryString)
        subPackets.append(output.packet)
        wholePacket += output.packet.wholePacket
        bitCountLeft = bitCountLeft - output.packet.wholePacket.count
        restOfBinaryString = output.restOfBinaryString
      } else {
        let output = try parseOperatorValue(binaryString: restOfBinaryString)
        subPackets.append(output.packet)
        wholePacket = wholePacket + output.packet.wholePacket
        bitCountLeft = bitCountLeft - (binaryString.count - output.restOfBinaryString.count)
        restOfBinaryString = output.restOfBinaryString
      }
    }
    
    let packet = OperatorPacket15(
      version: versionAndId.version,
      typeId: versionAndId.packetTypeId,
      wholePacket: wholePacket,
      packets: subPackets,
      lengthOfSubPackets: lengthOfSubPackets)
    
    return (packet: packet, restOfBinaryString: restOfBinaryString)
  }
  
  // DOES include header or 15/11 number
  private func parseAsOperator11(binaryString: String) throws -> (
    packet: OperatorPacket11, restOfBinaryString: String
  ) {
    let versionAndId = try getVersionAndId(binaryString: binaryString)
    let numberOfSubPackets = try String(binaryString[7...17]).convertBinaryToInt()
    
    var wholePacket = String(binaryString[...17]) // Beginnig of packet with version, id, bit type, bit count
    var restOfBinaryString = String(binaryString[18...])
    
    var subPackets: [Packet] = []
    var packetsLeft = numberOfSubPackets
    
    while (packetsLeft > 0 && restOfBinaryString.contains("1")) {
      let subPacketVersion = try getVersionAndId(binaryString: restOfBinaryString)
      
      if (subPacketVersion.packetTypeId == 4) {
        let output = try parseLiteralValue(binaryString: restOfBinaryString)
        subPackets.append(output.packet)
        wholePacket += output.packet.wholePacket
        packetsLeft -= 1
        restOfBinaryString = output.restOfBinaryString
      } else {
        let output = try parseOperatorValue(binaryString: restOfBinaryString)
        subPackets.append(output.packet)
        wholePacket = wholePacket + output.packet.wholePacket
        packetsLeft -= 1
        restOfBinaryString = output.restOfBinaryString
      }
    }
    
    let packet = OperatorPacket11(
      version: versionAndId.version,
      typeId: versionAndId.packetTypeId,
      wholePacket: wholePacket,
      packets: subPackets,
      numberOfSubPackets: numberOfSubPackets)
    
    return (packet: packet, restOfBinaryString: restOfBinaryString)
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
    self.forEach({ s in
      binaryString = binaryString + HexDictionary[String(s)]!
    })
    
    return binaryString
  }
  
  func convertBinaryToInt() throws -> Int {
    return Int(self, radix: 2)!
  }
  
  /// Pass the number you want in the first slice
  func splitAfter(count: Int) -> (firstSlice: String, restOfPacket: String) {
    let firstSlice = String(self[...(count - 1)])
    let restOfPacket = String(self[count...])
    
    return (firstSlice: firstSlice, restOfPacket: restOfPacket)
  }
}
