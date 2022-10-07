import {calculatePositionPart1, calculatePositionPart2} from "../Calculations";
import {Practice} from "../Practice";
import Input from "../Input";

describe("Day01 tests", () => {
  describe("part 1", () => {
    it("should calculate with the practice input", () => {
      expect(calculatePositionPart1(Practice)).toEqual(7)
    })

    it("should calculate with the actual input", () => {
      expect(calculatePositionPart1(Input)).toEqual(1462)
    })
  })

  describe("part 2", () => {
    it("should calculate with the practice input", () => {
      expect(calculatePositionPart2(Practice)).toEqual(5)
    })

    it("should calculate with the actual input", () => {
      expect(calculatePositionPart2(Input)).toEqual(1497)
    })
  })
})
