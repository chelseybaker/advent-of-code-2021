import Foundation
import Helpers

class Day01: AoCPrintable {
  let day: Int = 1
  let input: String = Day01Input.Input
  
  func calculatePart1(inputString: String) throws -> Int {
    let input = inputString.asIntArray()
    
    var increaseCount = 0

    for index in 1...(input.count - 1) {
      if (input[index] > input[index - 1]) { increaseCount += 1 }
    }
    
    return increaseCount
  }
  
  func calculatePart2(inputString: String) throws -> Int {
    
    let scans = inputString.asIntArray()
    var slidingWindows: [Int] = []
    
    for index in 2...scans.count - 1 {
      slidingWindows.append(scans[index] + scans[index - 1] + scans[index - 2])
    }
    
    var increaseCount = 0
    for index in 1...(slidingWindows.count - 1) {
      if (slidingWindows[index] > slidingWindows[index - 1]) { increaseCount += 1 }
    }
    
    return increaseCount

  }
}
