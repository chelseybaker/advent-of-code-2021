import {calculatePart1, calculatePart2, moveSeaOneStep, printFloor, readInput} from "../Calculations"
import Practice from "../Practice"
import Input from "../Input"

describe("Day25 tests", () => {
  describe("Part 1", () => {
    it("should calculate the practice", () => {
      expect(calculatePart1(Practice)).toEqual(58)
    })

    it("should calculate the input", () => {
      expect(calculatePart1(Input)).toEqual(504)
    })
  })

  describe("Part 2", () => {
    it("should calculate the practice", () => {
      expect(calculatePart2(Practice)).toEqual(0)
    })

    it("should calculate the input", () => {
      expect(calculatePart2(Input)).toEqual(0)
    })
  })
})
