import _ from "lodash"

type Index = {x: number; y: number}
const increaseCorners = (grid: number[][], center: Index): number => {
  const {x, y} = center
  let newFlashes = 0
  if (y > 0 && x > 0) {
    grid[x - 1][y - 1] += 1
    if (grid[x - 1][y - 1] === 10) newFlashes += 1
  }

  // B  x - 1, y
  if (x > 0) {
    grid[x - 1][y] += 1
    if (grid[x - 1][y] === 10) newFlashes += 1
  }

  // C x - 1, y + 1
  if (x > 0 && y < grid[x].length - 1) {
    grid[x - 1][y + 1] += 1
    if (grid[x - 1][y + 1] === 10) newFlashes += 1
  }

  // D x, y - 1
  if (y > 0) {
    grid[x][y - 1] += 1
    if (grid[x][y - 1] === 10) newFlashes += 1
  }

  // E
  if (y < grid[x].length - 1) {
    grid[x][y + 1] += 1
    if (grid[x][y + 1] === 10) newFlashes += 1
  }

  // F
  if (x < grid.length - 1 && y > 0) {
    grid[x + 1][y - 1] += 1
    if (grid[x + 1][y - 1] === 10) newFlashes += 1
  }

  // G
  if (x < grid.length - 1) {
    grid[x + 1][y] += 1
    if (grid[x + 1][y] === 10) newFlashes += 1
  }

  // H
  if (x < grid.length - 1 && y < grid[x].length - 1) {
    grid[x + 1][y + 1] += 1
    if (grid[x + 1][y + 1] === 10) newFlashes += 1
  }
  return newFlashes
}

const onlyNewIndicies = (existing: Index[], current: Index[]): Index[] => {
  const newOnes: Index[] = []
  current.forEach((c) => {
    if (existing.filter((a) => a.x === c.x && a.y === c.y).length === 0) newOnes.push(c)
  })
  return newOnes
}

export const calculatePart1 = (inputString: string): number => {
  let octopusGrid = inputString.split("\n").map((line) => line.split("").map((v) => _.parseInt(v)))

  let totalFlashes = 0

  for (let i = 0; i < 100; i++) {
    // the energy level of each octopus increases by 1.
    octopusGrid = octopusGrid.map((row) => row.map((num) => num + 1))

    let tenIndicies: Index[] = octopusGrid
      .map((row, x) => row.map((num, y) => (num === 10 ? {x: x, y: y} : undefined)))
      .flat()
      .filter((v) => !!v) as Index[]
    while (tenIndicies.length > 0) {
      totalFlashes += 1
      let index = tenIndicies.shift() as Index
      increaseCorners(octopusGrid, index)
      octopusGrid[index.x][index.y] += 1 // SO it's no longer ten
      let newTenIndicies: Index[] = octopusGrid
        .map((row, x) => row.map((num, y) => (num === 10 ? {x: x, y: y} : undefined)))
        .flat()
        .filter((v) => !!v) as Index[]

      tenIndicies.push(...onlyNewIndicies(tenIndicies, newTenIndicies))
    }
    octopusGrid = octopusGrid.map((row) => row.map((num) => (num > 9 ? 0 : num)))
  }

  return totalFlashes
}

export const calculatePart2 = (inputString: string): number => {
  let ocutopusGrid = inputString.split("\n").map((line) => line.split("").map((v) => _.parseInt(v)))

  let stepFlash = 0

  let i = 0
  while (stepFlash === 0) {
    i = i + 1

    // the energy level of each octopus increases by 1.
    ocutopusGrid = ocutopusGrid.map((row) => row.map((num) => num + 1))

    let tenIndicies: Index[] = ocutopusGrid
      .map((row, x) => row.map((num, y) => (num === 10 ? {x: x, y: y} : undefined)))
      .flat()
      .filter((v) => !!v) as Index[]
    while (tenIndicies.length > 0) {
      let index = tenIndicies.shift() as Index
      increaseCorners(ocutopusGrid, index)
      ocutopusGrid[index.x][index.y] += 1 // SO it's no longer ten
      let newTenIndicies: Index[] = ocutopusGrid
        .map((row, x) => row.map((num, y) => (num === 10 ? {x: x, y: y} : undefined)))
        .flat()
        .filter((v) => !!v) as Index[]

      tenIndicies.push(...onlyNewIndicies(tenIndicies, newTenIndicies))
    }
    ocutopusGrid = ocutopusGrid.map((row) => row.map((num) => (num > 9 ? 0 : num)))
    if (stepFlash === 0 && ocutopusGrid.flat().filter((num) => num === 0).length === ocutopusGrid.flat().length)
      stepFlash = i
  }

  return stepFlash
}
