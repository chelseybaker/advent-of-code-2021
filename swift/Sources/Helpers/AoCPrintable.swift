import Foundation

public enum AoCError: Error {
  
  case NotYetImplemented
  // General error to supply simple debugging messaging without creating a new error every time
  case GeneralError(_ message: String)
  
  var message: String {
    switch self {
    case .NotYetImplemented: return "The calculations for this day have not yet been created"
    case .GeneralError(let message): return message
    }
  }
}

/// Each day can follow this protocol so all of the answers can be printed out
public protocol AoCPrintable {
  var day: Int { get }
  
  var input: String { get }
  
  func calculatePart1(inputString: String) throws -> Int
  
  func calculatePart2(inputString: String) throws -> Int
}

public extension AoCPrintable {
  /// Returns a summary of the day's calculations
  func summary() -> String {
    let part1Answer = try? calculatePart1(inputString: input)
    let part2Answer = try? calculatePart2(inputString: input)
    
    let part1 = part1Answer != nil ? String(part1Answer!) : "----"
    let part2 = part2Answer != nil ? String(part2Answer!) : "----"
    
    return "Day \(String(format: "%02d", day)): \(part1) | \(part2)"
  }
}
