import Foundation

public extension String {
  func asLineByLineArray() -> [String] {
    return self.components(separatedBy: "\n")
  }
  
  func asIntArray() -> [Int] {
    return self.asLineByLineArray().compactMap({ Int($0 )})
  }
}

/// Pulled from https://stackoverflow.com/questions/45562662/how-can-i-use-string-substring-in-swift-4-substringto-is-deprecated-pleas
public extension String {
  subscript(value: Int) -> Character {
    self[index(at: value)]
  }
}

public extension String {
  subscript(value: NSRange) -> Substring {
    self[value.lowerBound..<value.upperBound]
  }
}

public extension String {
  subscript(value: CountableClosedRange<Int>) -> Substring {
    self[index(at: value.lowerBound)...index(at: value.upperBound)]
  }

  subscript(value: CountableRange<Int>) -> Substring {
    self[index(at: value.lowerBound)..<index(at: value.upperBound)]
  }

  subscript(value: PartialRangeUpTo<Int>) -> Substring {
    self[..<index(at: value.upperBound)]
  }

  subscript(value: PartialRangeThrough<Int>) -> Substring {
    self[...index(at: value.upperBound)]
  }

  subscript(value: PartialRangeFrom<Int>) -> Substring {
    self[index(at: value.lowerBound)...]
  }
}

private extension String {
  func index(at offset: Int) -> String.Index {
    index(startIndex, offsetBy: offset)
  }
}

extension String {
  public func convertBinaryToInt() throws -> Int {
    return Int(self, radix: 2)!
  }
}

extension String {
  var length: Int {
    return count
  }
  
  func substring(fromIndex: Int) -> String {
    return self[min(fromIndex, length) ..< length]
  }
  
  func substring(toIndex: Int) -> String {
    return self[0 ..< max(0, toIndex)]
  }
  
  subscript (r: Range<Int>) -> String {
    let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                        upper: min(length, max(0, r.upperBound))))
    let start = index(startIndex, offsetBy: range.lowerBound)
    let end = index(start, offsetBy: range.upperBound - range.lowerBound)
    return String(self[start ..< end])
  }
  
  public mutating func pop(fromFront: Bool = false) -> String? {
    if self.count == 0 { return nil }
    if fromFront {
      let first = self.first != nil ? String(self.first!) : nil
      self = self.substring(fromIndex: 1)
      return first
    } else {
      let last = self.last != nil ? String(self.last!) : nil
      self = self.substring(toIndex: (self.count - 1))
      return last
    }
  }
}
