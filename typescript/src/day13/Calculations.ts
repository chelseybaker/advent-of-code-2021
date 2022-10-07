import _ from "lodash"

type Index = {
  x: number
  y: number
}

const filterUniqueIndicies = (indicies: Index[]): Index[] => {
  return _.uniqWith(indicies, _.isEqual)
}

export const calculatePart1 = (inputString: string): number => {
  const [coordinateInput, foldDirections] = inputString.split("\n\n")

  const coordinates = coordinateInput.split("\n").map((stringCoordinate) => {
    const [x, y] = stringCoordinate.split(",").map((v) => _.parseInt(v))
    return {x: x, y: y}
  })

  const [firstFold] = foldDirections.split("\n")
  const [foldDirectionString, foldNumString] = firstFold.split("=")
  if (!foldNumString || !foldDirectionString) return 0
  const foldNum = _.parseInt(foldNumString)
  let foldedCoordinates: Index[] = []

  if (foldDirectionString.includes("y")) {
    // horizontal fold
    // take all Y numbers and mod foldNum them
    foldedCoordinates = coordinates.map((c) => ({x: c.x, y: c.y > foldNum ? c.y - 2 * (c.y - foldNum) : c.y}))
  } else {
    // vertical fold
    // Take all X numbers and mod foldNum them
    foldedCoordinates = coordinates.map((c) => ({x: c.x > foldNum ? c.x - 2 * (c.x - foldNum) : c.x, y: c.y}))
  }

  return filterUniqueIndicies(foldedCoordinates).length
}

export const calculatePart2 = (inputString: string): string => {
  const [coordinateInput, foldDirections] = inputString.split("\n\n")

  let coordinates = coordinateInput.split("\n").map((stringCoordinate) => {
    const [x, y] = stringCoordinate.split(",").map((v) => _.parseInt(v))
    return {x: x, y: y}
  })

  foldDirections.split("\n").forEach((direction) => {
    const [foldDirectionString, foldNumString] = direction.split("=")
    const foldNum = _.parseInt(foldNumString)
    if (!foldNumString || !foldDirectionString) return 0

    if (foldDirectionString.includes("y")) {
      // horizontal fold
      // take all Y numbers and mod foldNum them
      coordinates = coordinates.map((c) => ({x: c.x, y: c.y > foldNum ? c.y - 2 * (c.y - foldNum) : c.y}))
    } else {
      // vertical fold
      // Take all X numbers and mod foldNum them
      coordinates = coordinates.map((c) => ({x: c.x > foldNum ? c.x - 2 * (c.x - foldNum) : c.x, y: c.y}))
    }
  })

  const highX = _.head(coordinates.sort((a, b) => b.x - a.x))?.x
  const highY = _.head(coordinates.sort((a, b) => b.y - a.y))?.y

  if (!highX || !highY) return ""
  const letterMatrix: string[][] = []

  for (let x = 0; x <= highX; x++) {
    letterMatrix[x] = []
    for (let y = 0; y <= highY; y++) {
      const character = coordinates.filter((c) => c.x === x && c.y === y).length > 0 ? "#" : " "
      letterMatrix[x].push(character)
    }
  }

  return letterMatrix.map((row) => row.join("")).join("\n")
}
