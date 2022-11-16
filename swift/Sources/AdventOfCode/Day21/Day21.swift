import Foundation
import Helpers

enum Power {
  case on
  case off
}

struct AxisRange {
  let min: Int
  let max: Int
}

struct Step {
  let power: Power
  let xRange: AxisRange
  let yRange: AxisRange
  let zRange: AxisRange
}

// We could keep an array of all that are on, but that seems ridic
// Dictionary?
// Dictionary of dictionary of array

// Dictionary of dictionary of array
// X is the top key, y is the middle key, and the array is all the on Zs
typealias OnGrid = [Int: [Int: [Int]]]

class Day21 {
  
  private let input: String
  
  init(input: String) {
    self.input = input
  }
  
  func calculatePart1() throws -> Int {
    var grid: OnGrid = [:]
    let steps = try readInput(input: input)
    
    for step in steps {
      let xMin = max(-50, step.xRange.min)
      let xMax = min(50, step.xRange.max)
      if (xMin > xMax) { continue }
      
      for xStep in xMin...xMax {
        let yMin = max(-50, step.yRange.min)
        let yMax = min(50, step.yRange.max)
        if (yMin > yMax) { continue }
        for yStep in yMin...yMax {
     
          let zMin = max(-50, step.zRange.min)
          let zMax = min(50, step.zRange.max)
          if (zMin > zMax) { continue }
          let zs = Array(zMin...zMax)
          turn(x: xStep, y: yStep, z: zs, power: step.power, grid: &grid)
        }
      }
    }
    
    var count = 0
    
    for x in grid.keys {
      for y in grid[x]!.keys {
        count += grid[x]![y]!.count
      }
    }
    
    return count
  }
  
  func calculatePart2() throws -> Int {
    var grid: OnGrid = [:]
    let steps = try readInput(input: input)
    
    for step in steps {
      let xMin = step.xRange.min // max(-50, step.xRange.min)
      let xMax = step.xRange.max // min(50, step.xRange.max)
      if (xMin > xMax) { continue }
      
      for xStep in xMin...xMax {
        let yMin = step.yRange.min // max(-50, step.yRange.min)
        let yMax = step.yRange.max //  min(50, step.yRange.max)
        if (yMin > yMax) { continue }
        for yStep in yMin...yMax {
          
          
          turn(x: xStep, y: yStep, z: Array(step.zRange.min...step.zRange.max), power: step.power, grid: &grid)
        }
      }
    }
    
    var count = 0
    
    for x in grid.keys {
      for y in grid[x]!.keys {
        count += grid[x]![y]!.count
      }
    }
    
    return count
    
  }
  
  func turn(x: Int, y: Int, z: [Int], power: Power, grid: inout OnGrid) {
    if power == Power.on {
      if grid[x] == nil {
        grid[x] = [y: z]
        print("Turning ON \(x),\(y),\(z)")
      } else if grid[x]![y] == nil {
        grid[x]![y] = z
        print("Turning On \(x),\(y),\(z)")
      } else {
        let newZs = grid[x]![y]! + z
        grid[x]![y] = newZs.unique()
        print("Turning ON \(x),\(y),\(z)")
      }
    } else {
      if let zs = grid[x]?[y] {
        let newZs = zs.filter({ !z.contains($0) })
        if newZs.isEmpty {
          grid[x]![y] = nil
        } else {
          grid[x]![y] = newZs
        }
        print("Turning OFF \(x),\(y),\(z)")
      }
    }
  }
  
  func readInput(input: String) throws -> [Step] {
    // Dictionary of all that are on?
    var steps: [Step] = []
    let lines = input.components(separatedBy: "\n")
    for line in lines {
      let power = line.starts(with: "on") ? Power.on : Power.off
      let xValues = try getValue(value: "x", line: line)
      let yValues = try getValue(value: "y", line: line)
      let zValues = try getValue(value: "z", line: line)
      let step = Step(power: power, xRange: xValues, yRange: yValues, zRange: zValues)
      steps.append(step)
    }
    return steps
  }
  
  private func getValue(value: String, line: String) throws -> AxisRange {
    let values = try line.matches(for: "\(value)=(-?[0-9]+)..(-?[0-9]+)").compactMap({ Int($0) })
    if (values.count != 2) {
      throw AoCError.GeneralError("Error parsing values")
      
    }
    
    return AxisRange(min: values[0], max: values[1])
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

extension Array where Element == Int {
  func unique() -> [Int] {
    var uniquePoints: [Int] = []
    for beacon in self {
      if (!uniquePoints.contains(beacon)) { uniquePoints.append(beacon)}
    }
    return uniquePoints
  }
}
