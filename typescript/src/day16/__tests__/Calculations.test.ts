import {calculatePart1, calculatePart2} from "../Calculations"
import Practice from "../Practice"
import Input from "../Input"

describe("Day16 tests", () => {
  describe("Part 1", () => {
    it("should calculate the practice", () => {
      expect(calculatePart1("110100101111111000101000")).toEqual(2021)
    })

    // it("should calculate the input", () => {
    //   expect(calculatePart1(Input)).toEqual(2509)
    // })
  })
  //
  // describe("Part 2", () => {
  //   it("should calculate the practice", () => {
  //     expect(calculatePart2(Practice)).toEqual(2188189693529)
  //   })
  //
  //   it("should calculate the input", () => {
  //     expect(calculatePart2(Input)).toEqual(2827627697643)
  //   })
  // })
})
