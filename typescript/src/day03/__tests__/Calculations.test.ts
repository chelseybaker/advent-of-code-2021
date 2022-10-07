import {calculatePart1, calculatePart2} from "../Calculations"
import Part1Practice from "../Part1Practice"

describe("Day03 tests", () => {
  describe("part 1", () => {
    it("should calculate part 1", () => {
      expect(calculatePart1(Part1Practice)).toEqual(198)
    })
  })

  describe("part 2", () => {
    it("should calculate part 2", () => {
      expect(calculatePart2(Part1Practice)).toEqual(230)
    })
  })
})
