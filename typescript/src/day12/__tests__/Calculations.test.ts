import {calculatePart1, calculatePart2, NodeTree} from "../Calculations"
import Practice from "../Practice"
import Input from "../Input"
import Practice2 from "../Practice2"

describe("Day12 tests", () => {
  describe("Part 1", () => {
    it("should calculate the practice", () => {
      expect(calculatePart1(Practice)).toEqual(10)
    })

    it("should calculate the practice 2", () => {
      expect(calculatePart1(Practice2)).toEqual(19)
    })

    it("should calculate the input", () => {
      expect(calculatePart1(Input)).toEqual(5228)
    })
  })

  describe("Part 2", () => {
    it("should calculate the practice", () => {
      expect(calculatePart2(Practice)).toEqual(36)
    })

    it("should calculate the input", () => {
      expect(calculatePart2(Input)).toEqual(131228)
    })
  })
})
