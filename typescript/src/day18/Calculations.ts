import _, {flatten, isNaN} from "lodash"
import Input from "../day01/Input"

/**
 * To reduce a snailfish number, you must repeatedly do the first action in this list
 * that applies to the snailfish number:

 If any pair is nested inside four pairs, the leftmost such pair explodes.
 If any regular number is 10 or greater, the leftmost such regular number splits.
 Once no action in the above list applies, the snailfish number is reduced.

 During reduction, at most one action applies, after which the process returns to
 the top of the list of actions. For example, if split produces a pair that meets
 the explode criteria, that pair explodes before other splits occur.

 To explode a pair, the pair's left value is added to the first regular number to the
 left of the exploding pair (if any), and the pair's right value is added to the first
 regular number to the right of the exploding pair (if any). Exploding pairs will
 always consist of two regular numbers. Then, the entire exploding pair is replaced
 with the regular number 0.

 To split a regular number, replace it with a pair; the left element of the pair should
 be the regular number divided by two and rounded down, while the right element of the
 pair should be the regular number divided by two and rounded up. For example, 10
 becomes [5,5], 11 becomes [5,6], 12 becomes [6,6], and so on.
 */

// type Pair = {
//   id: string
//   left: number | Pair
//   right: number | Pair
//   parentId: string | undefined
// }
//
// const generateId = () => (Math.random() + 1).toString(36).substring(7)
//
// export const makePairs = (inputString: string, parentId?: string): Pair => {
//   const newString = inputString.replace(/^\[/, "").replace(/]$/, "")
//   if (!newString.includes("[") && !newString.includes("]")) {
//     // Regular number pair
//     const [left, right] = newString.split(",").map((v) => _.parseInt(v))
//     return {left: left, right: right, parentId: parentId, id: generateId()}
//   }
//   let bracketCount = 0
//   for (let i = 0; i < newString.length; i++) {
//     if (newString[i] === "[") bracketCount += 1
//     if (newString[i] === "]") bracketCount -= 1
//     if (bracketCount === 0) {
//       if (newString[i + 1] !== ",") throw new Error("Expected comma not found")
//       const left = newString
//         .split("")
//         .splice(0, i + 1)
//         .join("")
//       const right = newString
//         .split("")
//         .splice(i + 2)
//         .join("")
//
//       const leftNum = _.parseInt(left)
//       const rightNum = _.parseInt(right)
//       const myId = generateId()
//       const leftNode = _.isNaN(leftNum) ? makePairs(left, myId) : leftNum
//       const rightNode = _.isNaN(rightNum) ? makePairs(right, myId) : rightNum
//
//       return {
//         left: leftNode,
//         right: rightNode,
//         id: myId,
//         parentId: parentId,
//       }
//     }
//   }
// }
//
// export const pairToString = (pair: Pair): string => {
//   const left = isPair(pair.left) ? pairToString(pair.left) : pair.left.toString()
//   const right = isPair(pair.right) ? pairToString(pair.right) : pair.right.toString()
//   return `[${left},${right}]`
// }
//
// const isPair = (object: unknown): object is Pair => {
//   const pair = object as Pair
//   return _.isObject(pair) && !_.isUndefined(pair.left) && !_.isUndefined(pair.right)
// }
//
// // Used when appending the RIGHT value
// const addToLeftMost = (value: number, pair: Pair): void => {
//   if (_.isNumber(pair.left)) {
//     pair.left = value + pair.left
//
//     return
//   } else if (isPair(pair)) {
//     addToLeftMost(value, pair.left)
//   }
// }
//
// // Used when doing the LEFT number
// const addToRightMost = (value: number, pair: Pair): void => {
//   if (_.isNumber(pair.right)) {
//     pair.right = value + pair.right
//     return
//   } else if (isPair(pair)) {
//     addToRightMost(value, pair.right)
//   }
// }
//
// export const explodeNumber = (pair: Pair): boolean => {
//   const flattenedPairs = flattenPairs(pair)
//   return !_.isUndefined(recursiveExplode(pair, 0, flattenedPairs))
// }
//
// const recursiveExplode = (
//   pair: Pair,
//   level: number,
//   flattenedPairs: Pair[]
// ): {left: number; right: number} | undefined => {
//   if (level === 3) {
//     if (isPair(pair.left)) {
//       // Explode left
//
//       const {left, right} = pair.left
//       // [9, 8] becomes 0
//       // need to push up the 9 and 8 to be re distributed
//       splitPairLeft(pair.left, flattenedPairs)
//       pair.left = 0
//       return {left: left as number, right: right as number}
//     } else if (isPair(pair.right)) {
//       // Explode right
//       const {left, right} = pair.right
//       splitPairRight(pair.right, flattenedPairs)
//       pair.right = 0
//       return {left: left as number, right: right as number}
//     } else {
//       // Neither needed to explode
//       return undefined
//     }
//   }
//
//   const leftExplode = isPair(pair.left) ? recursiveExplode(pair.left, level + 1, flattenedPairs) : undefined
//   if (!leftExplode) {
//     const rightExplode = isPair(pair.right) ? recursiveExplode(pair.right, level + 1, flattenedPairs) : undefined
//     return rightExplode
//   }
//
//   return leftExplode
// }
//
// const flattenPairs = (topPair: Pair): Pair[] => {
//   let pairs: Pair[] = [topPair]
//   if (isPair(topPair.left)) pairs.push(...flattenPairs(topPair.left))
//   if (isPair(topPair.right)) pairs.push(...flattenPairs(topPair.right))
//   return pairs
// }
//
// const splitPairLeft = (fromPair: Pair, flattenedPairs: Pair[]): void => {
//   if (!_.isNumber(fromPair.left) || !_.isNumber(fromPair.right)) throw new Error("Expected a number")
//   const rightValue = fromPair.right as number
//   const parentPair = _.head(flattenedPairs.filter((pair) => pair.id === fromPair.parentId))
//   if (!parentPair) return
//   if (_.isNumber(parentPair.right)) parentPair.right += rightValue
//   else addToLeftMost(rightValue, parentPair.right)
// }
//
// const splitPairRight = (fromPair: Pair, flattenedPairs: Pair[]): void => {
//   if (!_.isNumber(fromPair.left) || !_.isNumber(fromPair.right)) throw new Error("Expected a number")
//   const leftValue = fromPair.left as number
//   const parentPair = _.head(flattenedPairs.filter((pair) => pair.id === fromPair.parentId))
//   if (!parentPair) return
//   if (_.isNumber(parentPair.left)) parentPair.left += leftValue
//   else addToLeftMost(leftValue, parentPair.left)
// }

const makeArray = (inputString: string): string[] => {
  let myArray: string[] = []
  let index = 0
  while (index < inputString.length) {
    if (["[", "]", ","].includes(inputString[index])) {
      myArray.push(inputString[index])
      index += 1
      continue
    }

    if (inputString[index] === ",") {
      index += 1
      continue
    }

    let numString = ""
    while (!_.isNaN(parseInt(inputString[index]))) {
      numString += inputString[index]
      index += 1
    }
    myArray.push(numString)

    if (["[", "]", ","].includes(inputString[index])) {
      myArray.push(inputString[index])
    }
    index += 1
  }
  return myArray
}

export const explodeNumber = (inputString: string): string => {
  let myArray: string[] = makeArray(inputString)

  let bracketCount = 0
  let bracketIndex: number | undefined = undefined
  let index = 0
  while (index < myArray.length) {
    if (myArray[index] === "[") bracketCount += 1
    if (myArray[index] === "]") bracketCount -= 1
    if (bracketCount === 5) {
      bracketIndex = index
      index = myArray.length
    }
    index++
  }

  if (!bracketIndex) return myArray.join("")

  const left = _.parseInt(myArray[bracketIndex + 1])
  const right = _.parseInt(myArray[bracketIndex + 3])
  index = bracketIndex

  while (index >= 0) {
    if (!_.isNaN(_.parseInt(myArray[index]))) {
      const existingValue = _.parseInt(myArray[index])
      const newValue = existingValue + left
      myArray[index] = newValue.toString()
      index = -1
    }
    index -= 1
  }

  index = bracketIndex + 4
  while (index < myArray.length) {
    if (!_.isNaN(_.parseInt(myArray[index]))) {
      const existingValue = _.parseInt(myArray[index])
      const newValue = existingValue + right
      myArray[index] = newValue.toString()
      index = myArray.length
    }
    index += 1
  }

  myArray.splice(bracketIndex, 5, "0")

  return myArray.join("")
}

export const splitNumber = (inputString: string): string => {
  let myArray: string[] = makeArray(inputString)
  let index = 0
  while (index < myArray.length) {
    if (!_.isNaN(_.parseInt(myArray[index]))) {
      let value = _.parseInt(myArray[index])
      if (value >= 10) {
        const left = Math.floor(value / 2)
        const right = Math.ceil(value / 2)
        myArray.splice(index, 1, "[", left.toString(), ",", right.toString(), "]")
        index = myArray.length
      }
    }
    index += 1
  }

  return myArray.join("")
}

export const addPairs = (pair1: string, pair2: string): string => {
  let newPair = "[" + pair1 + "," + pair2 + "]"
  let stillStuffToDo = true
  while (stillStuffToDo) {
    const explodedPair = explodeNumber(newPair)
    if (newPair != explodedPair) {
      newPair = explodedPair
      continue
    }
    const splitPair = splitNumber(newPair)
    if (newPair != splitPair) {
      newPair = splitPair
      continue
    }
    stillStuffToDo = false
  }
  return newPair
}

export const splitLeftRight = (input: string): {left: string; right: string} => {
  const correctHead = _.head(input) === "["
  const correctTail = _.last(input) === "]"
  if (!(correctHead && correctTail)) throw new Error("String malformed: " + input)

  let leftRightArray = makeArray(input)
  leftRightArray.shift()
  leftRightArray.pop()

  if (!leftRightArray.includes("[")) {
    const [left, right] = leftRightArray.join("").split(",")
    return {left: left, right: right}
  }

  let leftArray: string[] = []
  let rightArray: string[] = []
  let bracketCount = 0
  for (let x = 0; x < leftRightArray.length; x++) {
    if (leftRightArray[x] === "[") bracketCount += 1
    if (leftRightArray[x] === "]") bracketCount -= 1
    if (bracketCount === 0) {
      leftArray = leftRightArray.slice(0, x + 1)
      rightArray = leftRightArray.slice(x + 2)
      x = leftRightArray.length
    }
  }

  return {left: leftArray.join(""), right: rightArray.join("")}
}

export const calculateChecksum = (inputString: string): number => {
  /**
   * To check whether it's the right answer, the snailfish teacher only checks the
   * magnitude of the final sum. The magnitude of a pair is 3 times the magnitude of its
   * left element plus 2 times the magnitude of its right element. The magnitude of a regular
   * number is just that number.
   */

  const leftRight = splitLeftRight(inputString)
  const left = !_.isNaN(_.parseInt(leftRight.left)) ? _.parseInt(leftRight.left) : calculateChecksum(leftRight.left)
  const right = !_.isNaN(_.parseInt(leftRight.right)) ? _.parseInt(leftRight.right) : calculateChecksum(leftRight.right)

  return 3 * left + 2 * right
}

export const calculatePart1 = (inputString: string): number => {
  const allInput = inputString.split("\n")
  let baseInput = allInput[0]

  for (let x = 1; x < allInput.length; x++) {
    baseInput = addPairs(baseInput, allInput[x])
  }

  /**
   * To check whether it's the right answer, the snailfish teacher only checks the magnitude of the final sum.
   * The magnitude of a pair is 3 times the magnitude of its left element plus 2 times the magnitude of its
   * right element. The magnitude of a regular number is just that number.
   */

  return calculateChecksum(baseInput)
}

export const calculatePart2 = (inputString: string): number => {
  let max = 0
  const allInput = inputString.split("\n")

  for (let x = 0; x < allInput.length; x++) {
    for (let y = 0; y < allInput.length; y++) {
      if (x === y) continue
      let addedPairs = addPairs(allInput[x], allInput[y])
      let checksum = calculateChecksum(addedPairs)
      max = _.max([checksum, max]) as number
    }
  }

  return max
}
