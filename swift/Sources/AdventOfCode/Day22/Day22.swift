import Foundation
import Helpers

enum Power {
  case on
  case off
}

struct Cuboid {
  let x: ClosedRange<Int> // 10...12 is 10, 11, and 12
  let y: ClosedRange<Int>
  let z: ClosedRange<Int>
}

struct Step {
  let power: Power
  let cuboid: Cuboid
}

typealias OnGrid = [Cuboid]

class Day22 {
  
  private let input: [Step]
  
  init(input: String) throws {
    self.input = try Day22.parseInput(input: input)
  }
  
  func calculatePart1() throws -> Int {
    let minimum = -50
    let maximum = 50
    
    let steps: [Step] = input.compactMap({ step in
      let xLow = max(step.cuboid.x.lowerBound, minimum)
      let xHigh = min(step.cuboid.x.upperBound, maximum)
      if xLow > xHigh { return nil }
      
      let x = xLow...xHigh
      
      let yLow = max(step.cuboid.y.lowerBound, minimum)
      let yHigh = min(step.cuboid.y.upperBound, maximum)
      if yLow > yHigh { return nil }
      let y = yLow...yHigh

      
      let zLow = max(step.cuboid.z.lowerBound, minimum)
      let zHigh = min(step.cuboid.z.upperBound, maximum)
      if zLow > zHigh { return nil }
      
      let z = zLow...zHigh
      
      let cuboid = Cuboid(x: x, y: y, z: z)
      return Step(power: step.power, cuboid: cuboid)
    })
    
    var onCubes = Set<Cuboid>()
    
    for step in steps {
      let overlappingCubes = onCubes.filter({ step.cuboid.overlaps($0) })
      
      if (overlappingCubes.isEmpty && step.power == Power.on) {
        onCubes.insert(step.cuboid)
        continue
      }
      
      onCubes = onCubes.filter({ !overlappingCubes.contains($0) })
      
      let leftoverCubes = overlappingCubes
        .flatMap({ $0.subtract(step.cuboid) })
      
      onCubes = onCubes.union(leftoverCubes)
      
      if step.power == Power.on {
        onCubes.insert(step.cuboid)
      }
      
    }
    
    return onCubes.map({ $0.numberOfCubesInside() }).reduce(0, {$0 + $1})
  }
  
  func calculatePart2() throws -> Int {
    var onCubes = Set<Cuboid>()
    
    for step in input {
      let overlappingCubes = onCubes.filter({ step.cuboid.overlaps($0) })
      
      if (overlappingCubes.isEmpty && step.power == Power.on) {
        onCubes.insert(step.cuboid)
        continue
      }
      
      onCubes = onCubes.filter({ !overlappingCubes.contains($0) })
      
      let leftoverCubes = overlappingCubes
        .flatMap({ $0.subtract(step.cuboid) })
      
      onCubes = onCubes.union(leftoverCubes)
      
      if step.power == Power.on {
        onCubes.insert(step.cuboid)
      }
      
    }
    
    return onCubes.map({ $0.numberOfCubesInside() }).reduce(0, {$0 + $1})
  }
  
  static func parseInput(input: String) throws -> [Step] {
    // Dictionary of all that are on?
    var steps: [Step] = []
    let lines = input.components(separatedBy: "\n")
    for line in lines {
      let power = line.starts(with: "on") ? Power.on : Power.off
      let xValues = try getValue(value: "x", line: line)
      let yValues = try getValue(value: "y", line: line)
      let zValues = try getValue(value: "z", line: line)
      let cuboid = Cuboid(x: xValues, y: yValues, z: zValues)
      let step = Step(power: power, cuboid: cuboid)
      steps.append(step)
    }
    return steps
  }
  
  static private func getValue(value: String, line: String) throws -> ClosedRange<Int> {
    let values = try line.matches(for: "\(value)=(-?[0-9]+)..(-?[0-9]+)").compactMap({ Int($0) })
    if (values.count != 2) {
      throw AoCError.GeneralError("Error parsing values")
      
    }
    return values[0]...values[1]
  }
}

extension String {
  func matches(for pattern: String) throws -> [String] {
    let range = NSRange(location: 0, length: (self as NSString).length)
    let regex = try NSRegularExpression(pattern: pattern)
    let matches = regex.matches(in: self, range: range)
    var actualMatches: [String] = []
    for match in matches {
      for rangeIndex in 0..<match.numberOfRanges {
        let matchRange = match.range(at: rangeIndex)
        actualMatches.append((self as NSString).substring(with: matchRange))
      }
    }
    return actualMatches
  }
}

extension Cuboid: CustomDebugStringConvertible {
  var debugDescription: String {
    return "Cube x: (\(x.lowerBound)...\(x.upperBound)) y: (\(y.lowerBound)...\(y.upperBound)) z: (\(z.lowerBound)...\(z.upperBound))"
  }
}

extension Cuboid: Equatable {}

extension Cuboid: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(debugDescription)
  }
}

extension Cuboid {
  func overlaps(_ cuboid: Cuboid) -> Bool {
    return cuboid.x.overlaps(self.x) && cuboid.y.overlaps(self.y) && cuboid.z.overlaps(self.z)
  }
  
  func subtract(_ cuboid: Cuboid) -> Set<Cuboid> {
    if !self.overlaps(cuboid) { return [self] }
    
    if (cuboid.x.upperBound >= self.x.upperBound &&
        cuboid.x.lowerBound <= self.x.lowerBound &&
        cuboid.y.upperBound >= self.y.upperBound &&
        cuboid.y.lowerBound <= self.y.lowerBound &&
        cuboid.z.upperBound >= self.z.upperBound &&
        cuboid.z.lowerBound <= self.z.lowerBound) {
      return []
    }
    
    var cubes = Set<Cuboid>()
    
    // Is there a bottom cube?
    if self.y.lowerBound < cuboid.y.lowerBound {
      let cuboid = Cuboid(x: self.x, y: self.y.lowerBound...(cuboid.y.lowerBound - 1), z: self.z)
      cubes.insert(cuboid)
    }
    
    // Is there a top cube?
    if self.y.upperBound > cuboid.y.upperBound {
      let yRange = (cuboid.y.upperBound + 1)...self.y.upperBound
      let cuboid = Cuboid(x: self.x, y: yRange, z: self.z)
      cubes.insert(cuboid)
    }
    
    // Left with back, front, left, right.
    
    // Back
    if self.z.lowerBound < cuboid.z.lowerBound {
      let zRange = self.z.lowerBound...min(self.z.upperBound, (cuboid.z.lowerBound - 1))
      // Already cut off top and bottom, so the y should only be
      // cuboid in bounding box
      let yRange = max(self.y.lowerBound, cuboid.y.lowerBound)...min(self.y.upperBound, cuboid.y.upperBound)
      // Use Cuboid's y because we already cust off the top and bottom
      let cuboid = Cuboid(x: self.x, y: yRange, z: zRange)
      cubes.insert(cuboid)
    }
    
    // Front
    if self.z.upperBound > cuboid.z.upperBound {
      let zRange = max(self.z.lowerBound,(cuboid.z.upperBound + 1))...self.z.upperBound
      // Use Cuboid's y because we already cust off the top and bottom
      let yRange = max(self.y.lowerBound, cuboid.y.lowerBound)...min(self.y.upperBound, cuboid.y.upperBound)
      let cuboid = Cuboid(x: self.x, y: yRange, z: zRange)
      cubes.insert(cuboid)
    }
    
    // Left
    if self.x.lowerBound < cuboid.x.lowerBound {
      let xRange = self.x.lowerBound...min(self.x.upperBound,(cuboid.x.lowerBound - 1))
      // Use Cuboid's y and z because we already cust off the top and bottom
      let yRange = max(self.y.lowerBound, cuboid.y.lowerBound)...min(self.y.upperBound, cuboid.y.upperBound)
      
      let zRange = max(self.z.lowerBound, cuboid.z.lowerBound)...min(self.z.upperBound, cuboid.z.upperBound)
      
      let cuboid = Cuboid(x: xRange, y: yRange, z: zRange)
      
      cubes.insert(cuboid)
    }
    
    // Right
    if self.x.upperBound > cuboid.x.upperBound {
      // xRange should be
      
      let xRange = min(self.x.upperBound, (cuboid.x.upperBound + 1))...self.x.upperBound
      // Use Cuboid's y and z because we already cust off the top and bottom
      
      let yRange = max(self.y.lowerBound, cuboid.y.lowerBound)...min(self.y.upperBound, cuboid.y.upperBound)
      
      let zRange = max(self.z.lowerBound, cuboid.z.lowerBound)...min(self.z.upperBound, cuboid.z.upperBound)
      
      let cuboid = Cuboid(x: xRange, y: yRange, z: zRange)
      cubes.insert(cuboid)
    }
    
    return cubes
  }
}

extension Cuboid {
  func numberOfCubesInside() -> Int {
    let x = self.x.upperBound - self.x.lowerBound + 1
    let y = self.y.upperBound - self.y.lowerBound + 1
    let z = self.z.upperBound - self.z.lowerBound + 1
    
    return x * y * z
  }
}

extension Cuboid {
  func prettyPrint()  {
    for x in x.lowerBound...x.upperBound {
      for y in y.lowerBound...y.upperBound {
        for z in z.lowerBound...z.upperBound {
          print("\(x),\(y),\(z)")
        }
      }
    }
  }
}
