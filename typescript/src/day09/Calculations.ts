import _, {initial} from "lodash"
import Input from "../day01/Input"

export const calculatePart1 = (inputString: string): number => {
  const input = createMatrix(inputString)

  let total = 0

  input.forEach((row, indexX) => {
    row.forEach((num, indexY) => {
      const up = indexX !== 0 ? input[indexX - 1][indexY] : undefined
      if (_.isNumber(up) && up <= num) return
      const down = indexX !== input.length - 1 ? input[indexX + 1][indexY] : undefined
      if (_.isNumber(down) && down <= num) return
      const left = indexY !== 0 ? input[indexX][indexY - 1] : undefined
      if (_.isNumber(left) && left <= num) return
      const right = indexY !== row.length - 1 ? input[indexX][indexY + 1] : undefined
      if (_.isNumber(right) && right <= num) return
      // console.log(`Adding index (${indexX},${indexY}) with value ${num}`)
      total = total + num + 1
    })
  })

  return total
}

type Index = {
  x: number
  y: number
}

const arrayIncludesIndex = (indices: {x: number; y: number}[], index: {x: number; y: number}): boolean => {
  return indices.filter((i) => i.x === index.x && i.y === index.y).length > 0
}

export const createMatrix = (input: string) => input.split("\n").map((row) => row.split("").map((v) => _.parseInt(v)))

export const getUnfoundIndicies = (matrix: number[][], start: Index, existingIndicies: Index[]): Index[] => {
  const nonNine = getNonNineIndices(matrix, start)

  const newIndicies = nonNine.filter((i) => !arrayIncludesIndex(existingIndicies, i))
  return newIndicies
}

// Returns all the low points of each basin, so the start of each basin
export const getBasins = (input: number[][]): Index[] => {
  let lowPoints: Index[] = []
  input.forEach((row, indexX) => {
    row.forEach((num, indexY) => {
      const up = indexX !== 0 ? input[indexX - 1][indexY] : undefined
      if (_.isNumber(up) && up <= num) return
      const down = indexX !== input.length - 1 ? input[indexX + 1][indexY] : undefined
      if (_.isNumber(down) && down <= num) return
      const left = indexY !== 0 ? input[indexX][indexY - 1] : undefined
      if (_.isNumber(left) && left <= num) return
      const right = indexY !== row.length - 1 ? input[indexX][indexY + 1] : undefined
      if (_.isNumber(right) && right <= num) return

      const thisIndex = {x: indexX, y: indexY}
      lowPoints.push(thisIndex)
    })
  })
  return lowPoints
}

const getSurroundingIndicies = (matrix: number[][], start: Index): Index[] => {
  const oneIndex = start.x !== 0 ? {x: start.x - 1, y: start.y} : undefined
  const twoIndex = start.x !== matrix.length - 1 ? {x: start.x + 1, y: start.y} : undefined
  const threeIndex = start.y !== 0 ? {x: start.x, y: start.y - 1} : undefined
  const fourIndex = start.y !== matrix[start.x].length - 1 ? {x: start.x, y: start.y + 1} : undefined

  return [oneIndex, twoIndex, threeIndex, fourIndex].filter((i) => !!i) as Index[]
}

const getNonNineIndices = (matrix: number[][], start: Index): Index[] => {
  const surroundingIndices = getSurroundingIndicies(matrix, start)
  const nonNine = [...surroundingIndices].filter((i) => matrix[i.x][i.y] !== 9)
  return nonNine
}

const uniqueIndicies2 = (arr1: Index[], arr2: Index[]): Index[] => {
  return _.unionWith(arr1, arr2, (value1, value2) => value1.x === value2.x && value1.y === value2.y)
}

const recursiveCheck = (matrix: number[][], start: Index, existingIndicies: Index[]): Index[] => {
  const unfoundIndicies = getUnfoundIndicies(matrix, start, existingIndicies)
  if (unfoundIndicies.length === 0) return existingIndicies

  let combined = uniqueIndicies2(existingIndicies, unfoundIndicies) // The point, and all surrounding points

  unfoundIndicies.forEach((i) => {
    combined = uniqueIndicies2(combined, recursiveCheck(matrix, i, combined))
  })

  return uniqueIndicies2(combined, existingIndicies)
}

export const calculatePart2 = (inputString: string): number => {
  const matrix = createMatrix(inputString)
  const lowBasins = getBasins(matrix)

  const allBasinsSizes = lowBasins.map((b) => recursiveCheck(matrix, b, [b]).length).sort((a, b) => a - b)

  const total = allBasinsSizes.length
  return allBasinsSizes[total - 1] * allBasinsSizes[total - 2] * allBasinsSizes[total - 3]
}
