import {
  addPairs,
  calculateChecksum,
  calculatePart1,
  calculatePart2,
  explodeNumber,
  splitLeftRight,
  splitNumber,
} from "../Calculations"
import Practice from "../Practice"
import Input from "../Input"

describe("Day18 tests", () => {
  describe("Part 1", () => {
    it("should calculate the practice", () => {
      expect(calculatePart1(Practice)).toEqual(4140)
    })

    it("should calculate the input", () => {
      expect(calculatePart1(Input)).toEqual(4391)
    })
  })

  describe("Part 2", () => {
    it("should calculate the practice", () => {
      expect(calculatePart2(Practice)).toEqual(3993)
    })

    it("should calculate the input", () => {
      // higher than 4593
      expect(calculatePart2(Input)).toEqual(4626)
    })
  })
})

describe("exploding numbers", () => {
  // it("should not explode a base number", () => {
  //   const pair = makePairs("[1,2]")
  //   expect(explodeNumber(pair)).toEqual(false)
  //   expect(pairToString(pair)).toEqual("[1,2]")
  // })
  //
  // it("should not explode [[1,2],3]", () => {
  //   const pair = makePairs("[[1,2],3]")
  //   expect(explodeNumber(pair)).toEqual(false)
  //   expect(pairToString(pair)).toEqual("[[1,2],3]")
  // })
  //
  // it("should not explode [[1,9],[8,5]]", () => {
  //   const pair = makePairs("[[1,9],[8,5]]")
  //   expect(explodeNumber(pair)).toEqual(false)
  //   expect(pairToString(pair)).toEqual("[[1,9],[8,5]]")
  // })
  //
  // it("should explode [[[[0,9],2],3],4]", () => {
  //   const pair = makePairs("[[[[0,9],2],3],4]")
  //   expect(explodeNumber(pair)).toEqual(false)
  //   expect(pairToString(pair)).toEqual("[[[[0,9],2],3],4]")
  // })
  //
  // it("should explode [[[[[9,8],1],2],3],4]", () => {
  //   const pair = makePairs("[[[[[9,8],1],2],3],4]")
  //   expect(explodeNumber(pair)).toEqual(true)
  //   expect(pairToString(pair)).toEqual("[[[[0,9],2],3],4]")
  // })
  //
  // it("should explode [7,[6,[5,[4,[3,2]]]]]", () => {
  //   const pair = makePairs("[7,[6,[5,[4,[3,2]]]]]")
  //   expect(explodeNumber(pair)).toEqual(true)
  //   expect(pairToString(pair)).toEqual("[7,[6,[5,[7,0]]]]")
  // })
  //
  // it("should explode [[6,[5,[4,[3,2]]]],1]", () => {
  //   const pair = makePairs("[[6,[5,[4,[3,2]]]],1]")
  //   expect(explodeNumber(pair)).toEqual(true)
  //   expect(pairToString(pair)).toEqual("[[6,[5,[7,0]]],3]")
  // })

  // new
  it("should not explode [[[[0,9],2],3],4]", () => {
    expect(explodeNumber("[[[[0,9],2],3],4]")).toEqual("[[[[0,9],2],3],4]")
  })

  it("should explode [[[[[9,8],1],2],3],4]", () => {
    expect(explodeNumber("[[[[[9,8],1],2],3],4]")).toEqual("[[[[0,9],2],3],4]")
  })

  it("should explode [7,[6,[5,[4,[3,2]]]]]", () => {
    expect(explodeNumber("[7,[6,[5,[4,[3,2]]]]]")).toEqual("[7,[6,[5,[7,0]]]]")
  })

  it("should explode [[6,[5,[4,[3,2]]]],1]", () => {
    expect(explodeNumber("[[6,[5,[4,[3,2]]]],1]")).toEqual("[[6,[5,[7,0]]],3]")
  })

  it("should explode [[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]", () => {
    expect(explodeNumber("[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]")).toEqual("[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]")
  })

  it("should explode [[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]", () => {
    expect(explodeNumber("[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]")).toEqual("[[3,[2,[8,0]]],[9,[5,[7,0]]]]")
  })

  it("should split the number", () => {
    expect(splitNumber("[[[[0,7],4],[15,[0,13]]],[1,1]]")).toEqual("[[[[0,7],4],[[7,8],[0,13]]],[1,1]]")
  })

  it("should add the pairs", () => {
    expect(addPairs("[[[[4,3],4],4],[7,[[8,4],9]]]", "[1,1]")).toEqual("[[[[0,7],4],[[7,8],[6,0]]],[8,1]]")
  })
})

describe("Calculate sum", () => {
  it("should split the array", () => {
    expect(splitLeftRight("[0,9]")).toEqual({left: "0", right: "9"})
  })

  it("should split the deeper array", () => {
    expect(splitLeftRight("[[0,9],[1,2]]")).toEqual({left: "[0,9]", right: "[1,2]"})
  })

  it("should split the nested left array", () => {
    expect(splitLeftRight("[[[[0,9],2],3],4]")).toEqual({left: "[[[0,9],2],3]", right: "4"})
  })

  it("should split the nested right array", () => {
    expect(splitLeftRight("[7,[6,[5,[4,[3,2]]]]]")).toEqual({left: "7", right: "[6,[5,[4,[3,2]]]]"})
  })

  it("should calculate checksum", () => {
    expect(calculateChecksum("[[1,2],[[3,4],5]]")).toEqual(143)
  })

  it("should calculate checksum", () => {
    expect(calculateChecksum("[[[[0,7],4],[[7,8],[6,0]]],[8,1]]")).toEqual(1384)
  })
})
