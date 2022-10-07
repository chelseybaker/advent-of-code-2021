import Foundation

public extension String {
  func asLineByLineArray() -> [String] {
    return self.components(separatedBy: "\n")
  }
  
  func asIntArray() -> [Int] {
    return self.asLineByLineArray().compactMap({ Int($0 )})
  }
}
