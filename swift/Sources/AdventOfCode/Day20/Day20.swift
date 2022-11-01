import Foundation
import Helpers

let LightPixel = "#"
let DarkPixel = "."

typealias Image = [String]

struct ParsedInput {
  let algorithm: String
  let image: Image
}

struct Position {
  let x: Int
  let y: Int
}

class Day20 {
  let algorithm: String
  
  init(input: String) throws {
    let parsedInput = try Day20.readInput(input)
    algorithm = parsedInput.algorithm
  }
  
  func calculatePart1(inputString: String) throws -> Int {
    let image = try Day20.readInput(inputString).image
    let finalImage = try translateImage(image, numberOfTimes: 2)
    return finalImage.brightPixelCount()
  }
  
  func calculatePart2(inputString: String) throws -> Int {
    let image = try Day20.readInput(inputString).image
    let finalImage = try translateImage(image, numberOfTimes: 50)
    return finalImage.brightPixelCount()
  }
  
  func translateImage(_ image: Image, numberOfTimes: Int) throws -> Image {
    var lastImage = image
    lastImage.prettyPrint()
    for i in 1...numberOfTimes {
      print("On translation \(i)")
      lastImage = try padAndTranslate(lastImage, iteration: i)
    }
    return lastImage
  }
  
  private static func readInput(_ input: String) throws -> ParsedInput {
    let components = input.components(separatedBy: "\n\n")
    if (components.count != 2) { throw AoCError.GeneralError("Input is in unexpected format ") }
    
    let algorithm = components[0].replacingOccurrences(of: "\n", with: "")
    
    let image = components[1].components(separatedBy: "\n")
    
    return ParsedInput(algorithm: algorithm, image: image)
  }


  private func getTopRow(for pixel: Position, in image: Image, outsidePixel: String) -> String {
    /// pixel is in the top row, so return all dark pixels
    if (pixel.y == 0) { return outsidePixel + outsidePixel + outsidePixel }

    let y = pixel.y - 1

    /// Pixel is all the way on the left, so return dark pixels followed by the current pixel, followed by the next pixel
    if (pixel.x == 0) { return outsidePixel + image[y][0...1] }

    /// Pixel is all the way on the right, so return the one before, this pixel, and dark pixels
    if (pixel.x == image[y].count - 1) { return  image[y][(pixel.x - 1)...(pixel.x)] + outsidePixel }

    return image[y][(pixel.x - 1)...(pixel.x + 1)] + ""
  }

  private func getBottomRow(for pixel: Position, in image: Image, outsidePixel: String) -> String {
    /// Pixel is in the last row, so return all dark pixels
    if (pixel.y == image.count - 1) { return outsidePixel + outsidePixel + outsidePixel }

    let y = pixel.y + 1

    if (pixel.x == 0) { return outsidePixel + image[y][0...1] }

    if (pixel.x == image[y].count - 1) { return image[y][(pixel.x - 1)...pixel.x] + outsidePixel }

    return image[y][(pixel.x - 1)...(pixel.x + 1)] + ""
  }

  private func getMiddleRow(for pixel: Position, in image: Image, outsidePixel: String) -> String {
    let y = pixel.y

    if (pixel.x == 0) { return outsidePixel + image[y][0...1] }

    if (pixel.x == image[y].count - 1) { return image[y][(pixel.x - 1)...pixel.x] + outsidePixel }

    return image[y][(pixel.x - 1)...(pixel.x + 1)] + ""
  }

  private func getInt(for pixel: Position, in image: Image, outsidePixel: String) throws -> Int {
    let inputString = getTopRow(for: pixel, in: image, outsidePixel: outsidePixel) + getMiddleRow(for: pixel, in: image, outsidePixel: outsidePixel) + getBottomRow(for: pixel, in: image, outsidePixel: outsidePixel)

    let binaryString = inputString.replacingOccurrences(of: DarkPixel, with: "0").replacingOccurrences(of: LightPixel, with: "1")
    let index = try binaryString.convertBinaryToInt()
    return index
  }

  private func translatePixel(_ pixel: Position, in image: Image, outsidePixel: String) throws -> String {
    let index = try getInt(for: pixel, in: image, outsidePixel: outsidePixel)
    let value = algorithm[index]
    
    return String(value)
  }

  /// Pads the image with 5 empty rows on the top, bottom, left, and right
  private func padImage(_ image: Image, with padding: Int, outsidePixel: String) -> Image {
    let emptyRow = String(repeating: outsidePixel, count: image.count + padding + padding)
    var newImage: Image = []
    
    for _ in 1...padding {
      newImage.append(emptyRow)
    }
    
    let halfPad = String(repeating: outsidePixel, count: padding)
    for row in image {
      newImage.append(halfPad + row + halfPad)
    }
    
    for _ in 1...padding {
      newImage.append(emptyRow)
    }

    return newImage
  }

  private func translate(_ image: Image, outsidePixel: String) throws -> Image {
    var newImage: Image = []
    for y in 0..<image.count {
      var newRow = ""
      for x in 0..<image[y].count {
        newRow = newRow + (try translatePixel(Position(x: x, y: y), in: image, outsidePixel: outsidePixel))
      }
      newImage.append(newRow)
    }

    return newImage
  }
  
  private func padAndTranslate(_ image: Image, iteration: Int) throws -> Image {
    let outsidePixel = calculateOutsidePixel(iteration: iteration)
    let paddedImage = padImage(image, with: 2, outsidePixel: outsidePixel)
    return try translate(paddedImage, outsidePixel: outsidePixel)
  }
  
  private func calculateOutsidePixel(iteration: Int) -> String {
    if (String(algorithm[0]) == DarkPixel) { return DarkPixel }
    let outsidePixel = iteration % 2 == 0 ? LightPixel : DarkPixel
    return outsidePixel
  }
}

extension Image {
  /// Returns the number of pixels that are illuminated
  func brightPixelCount() -> Int {
    compactMap({ String($0) })
      .joined(separator: "")
      .filter({ String($0) == LightPixel })
      .count
  }
  
  func prettyPrint() {
    forEach({ print($0) })
  }
}
