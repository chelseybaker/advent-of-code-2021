import {calculatePart1, calculatePart2} from "../Calculations"
import Practice from "../Practice"
import Input from "../Input"

describe("DayXX tests", () => {
  describe("Part 1", () => {
    it("should calculate the practice", () => {
      expect(calculatePart1(Practice)).toEqual(15)
    })

    it("should calculate the input", () => {
      expect(calculatePart1(Input)).toEqual(514)
    })
  })

  describe("Part 2", () => {
    it("should calculate the practice", async () => {
      const answer = await calculatePart2(Practice)
      expect(answer).toEqual(1134)
    })

    it("should calculate the input", async () => {
      const answer = await calculatePart2(Input)
      expect(answer).toEqual(1103130)
    })
  })
})
