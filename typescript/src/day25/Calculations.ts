const EastFacing = ">"
const SouthFacing = "v"
const Empty = "."

export const calculatePart1 = (inputString: string): number => {
  var seaFloor = readInput(inputString)
  var steps = 0
  var stillMoving = true

  while (stillMoving) {
    steps += 1
    let newFloor = moveSeaOneStep(seaFloor)

    if (printFloor(newFloor) == printFloor(seaFloor)) {
      stillMoving = false
    }

    seaFloor = newFloor
  }

  return steps
}

export const calculatePart2 = (inputString: string): number => {
  return 0
}

export const moveSeaOneStep = (floor: string[][]): string[][] => {
  // Every step, the sea cucumbers in the east-facing herd attempt to move
  // forward one location, then the sea cucumbers in the south-facing herd attempt to move forward one location.

  let movingFloor: string[][] = floor.map((line) => line.map((s) => "."))

  for (let row = 0; row < floor.length; row++) {
    for (let column = 0; column < floor[row].length; column++) {
      if (floor[row][column] != EastFacing) {
        continue
      }

      const nextSpot = column == floor[row].length - 1 ? 0 : column + 1

      if (floor[row][nextSpot] == Empty) {
        movingFloor[row][nextSpot] = EastFacing
        movingFloor[row][column] = Empty
      } else {
        movingFloor[row][column] = EastFacing
      }
    }
  }

  for (let row = 0; row < floor.length; row++) {
    for (let column = 0; column < floor[row].length; column++) {
      if (floor[row][column] != SouthFacing) {
        continue
      }

      const nextSpot = row == floor.length - 1 ? 0 : row + 1

      if (movingFloor[nextSpot][column] != EastFacing && floor[nextSpot][column] != SouthFacing) {
        movingFloor[nextSpot][column] = SouthFacing
        movingFloor[row][column] = Empty
      } else {
        movingFloor[row][column] = SouthFacing
      }
    }
  }

  return movingFloor
}

export const readInput = (input: string): string[][] => {
  return input.split("\n").map((line) => line.split(""))
}

export const printFloor = (seafloor: string[][]): string => {
  return seafloor.map((row) => row.join("")).join("\n")
}
