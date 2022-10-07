import {calculatePositionPart1, calculatePositionPart2} from "../Calculations"
import part1practice from "../Part1practice"

describe("Day2 tests", () => {
  describe("part 1", () => {
    it("should calculate with the practice input", () => {
      expect(calculatePositionPart1(part1practice)).toEqual(150)
    })
  })

  describe("part 2", () => {
    it("should calculate with the practice input", () => {
      expect(calculatePositionPart2(part1practice)).toEqual(900)
    })
  })
})
