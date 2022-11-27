import Foundation
import Helpers

struct Velocity: Equatable, Hashable {
  let x: Int // forward, or backward if negative
  let y: Int // up if positive, down if negative
}

struct Range {
  let min: Int
  let max: Int
}

struct TargetArea {
  let x: Range
  let y: Range
}

struct ValidYVelocity {
  let velocity: Int // Y Velocity
  let time: Range // Time range where it's in target area
}

class Day17 {
  
  func calculatePart1(inputString: String) throws -> Int {
    let targetArea = try getTargetAreaFromInput(inputString)
    return calculateHighestYWithoutX(for: targetArea.y) ?? 0
  }
  
  func calculatePart2(inputString: String) throws -> Int {
    let targetArea = try getTargetAreaFromInput(inputString)
    return calculateDistinctVelocities(for: targetArea)
  }
  
  // Parses the input
  func getTargetAreaFromInput(_ inputString: String) throws -> TargetArea {
    let trimmedInput = inputString.replacingOccurrences(of: "target area: ", with: "")
    let output =  trimmedInput.components(separatedBy: ", ")
    guard output.count == 2 else {
      throw AoCError.GeneralError("Input could not be parsed")
    }
    
    let xRange = output[0].replacingOccurrences(of: "x=", with: "").components(separatedBy: "..")
    let yRange = output[1].replacingOccurrences(of: "y=", with: "").components(separatedBy: "..")
    guard let xMin = Int(xRange[0]), let xMax = Int(xRange[1]), let yMin = Int(yRange[0]), let yMax = Int(yRange[1]) else {
      throw AoCError.GeneralError("Target area could not be parsed")
    }
    return TargetArea(x: Range(min: xMin, max: xMax), y: Range(min: yMin, max: yMax))
  }
  
  // Doesn't take X steps into account. This may break for some puzzle inputs
  func calculateHighestYWithoutX(for yRange: Range) -> Int? {
    let maxVelocity = abs(yRange.min) - 1
    var highestY = 0
    var lastY = 0
    var time = 1
    
    var keepGoing = true
    
    // Probably a better way to do this
    while (keepGoing) {
      lastY = (time * maxVelocity) - ( (time - 1) * time / 2)
      if (lastY > highestY) { highestY = lastY } else {
        keepGoing = false
      }
      time += 1
    }
    
    return highestY
  }
  
  func calculateDistinctVelocities(for targetArea: TargetArea) -> Int {
    let validYVelocities = calculateValidYVelocities(targetArea: targetArea)
    
    var validVelocities: [Velocity] = []

    // Probably a better way to do this
    for yVelocity in validYVelocities {
      for time in yVelocity.time.min...yVelocity.time.max {

        var xVelocity = 0

        while (xVelocity <= targetArea.x.max) {
          let positionAtTime = calculateXPositionAtTime(time: time, velocity: xVelocity)
          
          if (isInRange(position: positionAtTime, range: targetArea.x)) {
            let velocity = Velocity(x: xVelocity, y: yVelocity.velocity)
            validVelocities.append(velocity)
          }
          
          xVelocity += 1
        }
      }
    }

    return Set(validVelocities).count
  }
  
  /// Calculates position of X at a specific point in time
  /// Handles if X is not moving
  func calculateXPositionAtTime(time: Int, velocity: Int) -> Int {
    // X will stop moving before time is up, so you can return the summation
    if (velocity <= time) { return velocity * (velocity + 1) / 2 }
    
    // Summation of the time with the difference of the velocity over time
    return time * (time + 1) / 2 + (velocity - time) * time
  }
  
  /// Calculates every y velocity that will put us in target area and the time which it's in there
  private func calculateValidYVelocities(targetArea: TargetArea) -> [ValidYVelocity] {
    var validYVelocities: [ValidYVelocity] = []
    
    let maxYVelocity = abs(targetArea.y.min) - 1
    
    for yVelocity in targetArea.y.min...maxYVelocity {
      var minTime: Int? = nil
      var maxTime: Int? = nil
      
      var yPosition = 0
      var time = 0
      
      // Probably a better way to do this
      while (yPosition >= targetArea.y.min) {
        let calculatedY = (time * yVelocity) - ( (time - 1) * time / 2)
        if (isInRange(position: calculatedY, range: targetArea.y)) {
          if (minTime == nil) { minTime = time }
          maxTime = time
        }
        yPosition = calculatedY
        time += 1
      }
      
      if let minTime = minTime, let maxTime = maxTime {
        let timeRange = Range(min: minTime, max: maxTime)
        let validYVelocity = ValidYVelocity(velocity: yVelocity,
                                            time: timeRange)
        validYVelocities.append(validYVelocity)
      }
    }
    return validYVelocities
  }
  
  /// Returns true if the position is in the range
  private func isInRange(position: Int, range: Range) -> Bool {
    return position >= range.min && position <= range.max
  }
}

