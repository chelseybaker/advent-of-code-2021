import {calculatePart1, calculatePart2} from "../Calculations"
import Practice from "../Practice"
import Input from "../Input"

describe("Day06 tests", () => {
  describe("Part 1", () => {
    it("should calculate the practice", () => {
      expect(calculatePart1(Practice)).toEqual(5934)
    })

    it("should calculate the input", () => {
      expect(calculatePart1(Input)).toEqual(354564)
    })
  })

  describe("Part 2", () => {
    it("should calculate the practice", () => {
      expect(calculatePart2(Practice)).toEqual(26984457539)
    })

    it("should calculate the input", () => {
      expect(calculatePart2(Input)).toEqual(1609058859115)
    })
  })
})
