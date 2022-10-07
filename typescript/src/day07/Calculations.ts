import _ from "lodash"

const calculateFuelCount = (
  inputString: string,
  fuelCalculator: (startingPosition: number, endingPosition: number) => number
): number => {
  const positions = inputString.split(",").map((v) => _.parseInt(v))
  const high = _.max(positions) ?? 0
  const low = _.min(positions) ?? 0

  let fuelTracker: {position: number; fuelCount: number} = {position: low, fuelCount: -1}
  for (let i = low; i <= high; i++) {
    const fuelCount = positions.map((v) => fuelCalculator(v, i)).reduce((a, b) => a + b)
    if (fuelTracker.fuelCount === -1) fuelTracker = {position: i, fuelCount: fuelCount}
    if (fuelCount < fuelTracker.fuelCount) fuelTracker = {position: i, fuelCount: fuelCount}
  }

  return fuelTracker.fuelCount
}

export const calculatePart1 = (inputString: string): number =>
  calculateFuelCount(inputString, (v, i) => Math.abs(i - v))

export const calculatePart2 = (inputString: string): number =>
  calculateFuelCount(inputString, (v, i) => {
    const n = Math.abs(i - v)
    return (n * (n + 1)) / 2
  })
