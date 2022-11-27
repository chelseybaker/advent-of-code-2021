import Foundation
import Helpers

class Day19 {
  
  func calculatePart1(inputString: String) throws -> Int {
    let scanners = rotateScanners(inputString: inputString)
    let uniqueCoordiantes = scanners.flatMap({ $0.beacons }).unique()
    return uniqueCoordiantes.count
  }
  
  func calculatePart2(inputString: String) throws -> Int {
    let scanners = rotateScanners(inputString: inputString)
    let scannerLocations = scanners.map({ $0.originalLocation })
    return calculateMaxManhattan(scanners: scannerLocations)
  }
  
  /// Parses input into the Scanner array
  func readInput(inputString: String) -> [UnknownScanner] {
    return inputString
      .components(separatedBy: "\n\n")
      .map { block in
        let coordinates = block.components(separatedBy: "\n")
        let name = coordinates[0].replacingOccurrences(of: "---", with: "").trimmingCharacters(in: .whitespaces)
        let beacons: [Coordinate] = coordinates[1...].map { coordinate in
          let points = coordinate.components(separatedBy: ",")
          return Coordinate(x: Int(points[0])!, y: Int(points[1])!, z: Int(points[2])!)
        }
        
        return UnknownScanner(name: name, beacons: beacons)
      }
  }
  
  func calculateMaxManhattan(scanners: [Coordinate]) -> Int {
    var biggestDistance = 0
    
    for indexA in 0..<(scanners.count - 1) {
      for indexB in (indexA + 1)..<scanners.count {
        let scannerA = scanners[indexA]
        let scannerB = scanners[indexB]
        let sum = calculateManhattanDistance(scannerA, scannerB)
        if (sum > biggestDistance) {biggestDistance = sum}
      }
    }
    
    return biggestDistance
  }
  
  /// Calculates the Manhattan Distance between two points
  func calculateManhattanDistance(_ coordinateA: Coordinate, _ coordinateB: Coordinate) -> Int {
    abs(coordinateA.x - coordinateB.x) + abs(coordinateA.y - coordinateB.y) + abs(coordinateA.z - coordinateB.z)
  }
  
  // TODO: This function is gross, need to refactor this
  func rotateUnknownScannerToKnownScanner(knownScanner: RotatedScanner, unknownScanner: UnknownScanner) -> RotatedScanner? {
    let knownScannerMagnitudes = knownScanner.vectorMagnitudes.map({ $0.magnitude })
    
    let matchingMagnitudes = unknownScanner.vectorMagnitudes.filter({ knownScannerMagnitudes.contains($0.magnitude) }).flatMap({ [$0.beaconA, $0.beaconB] }).unique()
    
    guard matchingMagnitudes.count >= 12 else { return nil }
    
    guard let firstMatchingMagnitude = unknownScanner.vectorMagnitudes.filter({ knownScannerMagnitudes.contains($0.magnitude) }).first else {
      return nil
    }
    
    guard let unknownScannerBeacons = unknownScanner.vectorMagnitudes.filter({ $0.magnitude == firstMatchingMagnitude.magnitude }).first else {
      return nil
    }
    
    guard let knownScannerBeacons = knownScanner.vectorMagnitudes.filter({ $0.magnitude == firstMatchingMagnitude.magnitude }).first else {
      return nil
    }
    
    // If the reversed comparison of beacons works, save it here
    var reverseOffset: Offset?
    var reverseRotation: ((Coordinate) -> Coordinate)?
    
    for rotation in rotations {
      let rotatedBeaconA = rotation(unknownScannerBeacons.beaconA)
      let rotatedBeaconB = rotation(unknownScannerBeacons.beaconB)
      
      let offsetA = rotatedBeaconA.calculateOffset(from: knownScannerBeacons.beaconA)
      let offsetB = rotatedBeaconB.calculateOffset(from: knownScannerBeacons.beaconB)
      
      if (offsetA == offsetB) {
        // Offset is ALWAYS the same no matter the rotation.
        // The rotation that happened IS the correction. So just get the offset and apply it to all the beacons?
        let rotatedBeacons = unknownScanner.beacons.map({ rotation($0).withOffset(offset: offsetA)})
        let originalCoordinate = Coordinate(x: -offsetA.xOffset, y: -offsetA.yOffset, z: -offsetA.zOffset)
        let scanner = RotatedScanner(name: unknownScanner.name, beacons: rotatedBeacons, originalLocation: originalCoordinate)
        return scanner
      }
      
      let offsetAR = rotatedBeaconB.calculateOffset(from: knownScannerBeacons.beaconA)
      let offsetBR = rotatedBeaconA.calculateOffset(from: knownScannerBeacons.beaconB)
      
      if (offsetAR == offsetBR) {
        reverseOffset = offsetAR
        reverseRotation = rotation
      }
    }
    
    // TODO: Figure out why you can't do this earlier in the for loop?
    if let reverseOffset = reverseOffset, let reverseRotation = reverseRotation {
      let rotatedBeacons = unknownScanner.beacons.map({ reverseRotation($0).withOffset(offset: reverseOffset)})
      let originalCoordinate = Coordinate(x: -reverseOffset.xOffset, y: -reverseOffset.yOffset, z: -reverseOffset.zOffset)
      let scanner = RotatedScanner(name: unknownScanner.name, beacons: rotatedBeacons, originalLocation: originalCoordinate)
      return scanner
    }
    
    return nil
  }
  
  func rotateScanners(inputString: String) -> [RotatedScanner] {
    let allScanners = readInput(inputString: inputString)
    
    // Scanners we know their beacons are rotated properly and offset by 0,0,0
    var knownScanners: [RotatedScanner] = [
      RotatedScanner(name: allScanners[0].name,
                     beacons: allScanners[0].beacons,
                     originalLocation: Coordinate(x: 0, y: 0, z: 0))
    ]
    
    var unmatchedScanners = allScanners[1...]
    
    while (unmatchedScanners.count > 0) {
      for scanner in unmatchedScanners {
        let overlappingScanner = scanner.firstOverlappingScanner(from: knownScanners)
        guard let overlappingScanner = overlappingScanner else { continue }
        
        let rotatedScanner = rotateUnknownScannerToKnownScanner(knownScanner: overlappingScanner, unknownScanner: scanner)
        guard let rotatedScanner = rotatedScanner else { continue }

        unmatchedScanners = unmatchedScanners.filter({ $0.name != scanner.name})
        knownScanners.append(rotatedScanner)
      }
    }
    
    return knownScanners
  }
}

struct Coordinate: Equatable {
  let x: Int
  let y: Int
  let z: Int
  
  var formatted: String {
    return "\(x),\(y),\(z)"
  }
  
  func withOffset(offset: Offset) -> Coordinate {
    Coordinate(x: x - offset.xOffset, y: y - offset.yOffset, z: z - offset.zOffset)
  }
}

struct Offset: Equatable {
  let xOffset: Int
  let yOffset: Int
  let zOffset: Int
  
  var formatted: String {
    return "\(xOffset),\(yOffset),\(zOffset)"
  }
}

struct VectorMagnitude {
  let beaconA: Coordinate
  let beaconB: Coordinate
  let magnitude: Double
}

protocol Scanner {
  var name: String { get }
  var beacons: [Coordinate] { get }
  var vectorMagnitudes: [VectorMagnitude] { get }
}

extension Scanner {
  var sortedVectorMagnitudes: [Double] {
    return vectorMagnitudes.map({ $0.magnitude }).sorted()
  }
  
  static func calculateVectorMagnitude(beacons: [Coordinate]) -> [VectorMagnitude] {
    var vectorMagnitudes: [VectorMagnitude] = []
    for indexA in 0...(beacons.count - 2) {
      for indexB in (indexA + 1)...(beacons.count - 1) {
        let beaconA = beacons[indexA]
        let beaconB = beacons[indexB]
        let magnitude = vectorMagnitude(beaconA, beaconB)
        let vectorMagnitude = VectorMagnitude(beaconA: beaconA, beaconB: beaconB, magnitude: magnitude)
        vectorMagnitudes.append(vectorMagnitude)
      }
    }
    return vectorMagnitudes.sorted(by: {$0.magnitude < $1.magnitude})
  }
  
  static func vectorMagnitude(_ beaconA: Coordinate, _ beaconB: Coordinate) -> Double {
    return sqrt(pow(Double(beaconA.x - beaconB.x), 2)
                + pow(Double(beaconA.y - beaconB.y), 2)
                + pow(Double(beaconA.z - beaconB.z), 2))
  }
}

/// Scanner whose coordinates we do not yet know
struct UnknownScanner: Scanner {
  let name: String
  private(set) var beacons: [Coordinate]
  private(set) var vectorMagnitudes: [VectorMagnitude]
  
  init(name: String, beacons: [Coordinate]) {
    self.name = name
    self.beacons = beacons
    self.vectorMagnitudes = UnknownScanner.calculateVectorMagnitude(beacons: beacons)
  }
}

/// Scanner whose beacons have been rotated
struct RotatedScanner: Scanner {
  let name: String
  let beacons: [Coordinate] // Beacons should be in coordinate related to 0,0,0
  let originalLocation: Coordinate
  let vectorMagnitudes: [VectorMagnitude]
  
  init(name: String, beacons: [Coordinate], originalLocation: Coordinate) {
    self.name = name
    self.beacons = beacons
    self.originalLocation = originalLocation
    self.vectorMagnitudes = UnknownScanner.calculateVectorMagnitude(beacons: beacons)
  }
}

extension Coordinate {
  func calculateOffset(from coordinate: Coordinate) -> Offset {
    let xOffset = x - coordinate.x
    let yOffset = y - coordinate.y
    let zOffset = z - coordinate.z
    return Offset(xOffset: xOffset, yOffset: yOffset, zOffset: zOffset)
  }
}

extension Array where Element == Coordinate {
  func unique() -> [Coordinate] {
    var uniquePoints: [Coordinate] = []
    for beacon in self {
      if (!uniquePoints.contains(beacon)) { uniquePoints.append(beacon)}
    }
    return uniquePoints
  }
}

extension UnknownScanner {
  func firstOverlappingScanner(from knownScanners: [RotatedScanner]) -> RotatedScanner? {
    knownScanners.first { scanner in
      let vectorMagnitudes = scanner.sortedVectorMagnitudes
      
      let overlappingMagnitudes = self.vectorMagnitudes.map({ $0.magnitude }).filter({ vectorMagnitudes.contains($0) })
      let uniqueBeacons = self.vectorMagnitudes.filter({ overlappingMagnitudes.contains($0.magnitude) }).flatMap({ [$0.beaconA, $0.beaconB] }).unique()
      
      if (uniqueBeacons.count >= 12) { return true }
      return false
    }
  }
}

let rotations: [(Coordinate) -> Coordinate] = [
  // Original
  {Coordinate(x: $0.x, y: $0.y, z: $0.z)},
  
  // Rotate around Y
  {Coordinate(x: $0.z, y: $0.y, z: -$0.x)},
  {Coordinate(x: -$0.x, y: $0.y, z: -$0.z)},
  {Coordinate(x: -$0.z, y: $0.y, z: $0.x)},
  
  // turn once to the right, rotate aroun y
  {Coordinate(x: $0.y, y: -$0.x, z: $0.z)},
  {Coordinate(x: $0.y, y: $0.z, z: $0.x)},
  {Coordinate(x: $0.y, y: $0.x, z: -$0.z)},
  {Coordinate(x: $0.y, y: -$0.z, z: -$0.x)},
  
  // turn once to the left, rotate around y
  {Coordinate(x: -$0.y, y: $0.x, z: $0.z)},
  {Coordinate(x: -$0.y, y: $0.z, z: -$0.x)},
  {Coordinate(x: -$0.y, y: -$0.x, z: -$0.z)},
  {Coordinate(x: -$0.y, y: -$0.z, z: $0.x)},
  
  // Upside down y and rotate around Y
  {Coordinate(x: -$0.x, y: -$0.y, z: $0.z)},
  {Coordinate(x: -$0.z, y: -$0.y, z: -$0.x)},
  {Coordinate(x: $0.x, y: -$0.y, z: -$0.z)},
  {Coordinate(x: $0.z, y: -$0.y, z: $0.x)},
  
  // Y facing back (as in -z direction), rotate around Y
  {Coordinate(x: $0.x, y: $0.z, z: -$0.y)},
  {Coordinate(x: $0.z, y: -$0.x, z: -$0.y)},
  {Coordinate(x: -$0.x, y: -$0.z, z: -$0.y)},
  {Coordinate(x: -$0.z, y: $0.x, z: -$0.y)},
  
  // Y facing forward (as in +z direction), rotate around y
  {Coordinate(x: $0.x, y: -$0.z, z: $0.y)},
  {Coordinate(x: -$0.z, y: -$0.x, z: $0.y)},
  {Coordinate(x: -$0.x, y: $0.z, z: $0.y)},
  {Coordinate(x: $0.z, y: $0.x, z: $0.y)}
]
