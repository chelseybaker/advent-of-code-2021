import {calculatePart1, calculatePart2, splitLine} from "../Calculations"
import Part1Practice from "../Part1Practice"
import Part1Input from "../Part1Input"

describe("Day05 tests", () => {
  it("should split the line", () => {
    expect(splitLine("0,9 -> 5,9")).toEqual({x1: 0, y1: 9, x2: 5, y2: 9})
  })

  it("part1", () => {
    expect(calculatePart1(Part1Practice)).toEqual(5)
  })

  it("part1 input", () => {
    // Correct answer: 6113
    expect(calculatePart1(Part1Input)).toEqual(6113)
  })

  it("part 2", () => {
    expect(calculatePart2(Part1Practice)).toEqual(12)
  })

  it("part 2 input", () => {
    // Correct answer: 20373
    expect(calculatePart2(Part1Input)).toEqual(20373)
  })
})
