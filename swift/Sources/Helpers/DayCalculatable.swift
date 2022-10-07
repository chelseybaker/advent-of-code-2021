import Foundation

public enum DayCalculatableError: Error {
  case NotYetImplemented
  
  var message: String {
    switch self {
    case .NotYetImplemented: return "The calculations for this day have not yet been created"
    }
  }
}

/// Each day can follow this protocol so all of the answers can be printed out
public protocol DayCalculatable {
  var day: Int { get }
  
  var input: String { get }
  
  func calculatePart1(inputString: String) throws -> Int
  
  func calculatePart2(inputString: String) throws -> Int
}

public extension DayCalculatable {
  /// Returns a summary of the day's calculations
  func summary() -> String {
    let part1Answer = try? calculatePart1(inputString: input)
    let part2Answer = try? calculatePart2(inputString: input)
    
    
    let part1 = part1Answer != nil ? String(format: "%04d", part1Answer!) : "----"
    let part2 = part2Answer != nil ? String(format: "%04d", part2Answer!) : "----"
    
    return "Day \(String(format: "%02d", day)): \(part1) | \(part2)"
  }
}
