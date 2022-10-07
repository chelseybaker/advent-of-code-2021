const calculateFish = (inputString: string, days: number): number => {
  const fishTracker: number[] = [0, 0, 0, 0, 0, 0, 0, 0, 0]
  const initialStateOfFish = inputString.split(",").map((v) => parseInt(v))
  initialStateOfFish.forEach((fishDay) => fishTracker[fishDay]++)

  for (let day = 1; day <= days; day++) {
    const zeroDayFishCount = fishTracker[0]
    for (let i = 1; i < 9; i++) {
      fishTracker[i - 1] = fishTracker[i]
    }

    fishTracker[8] = zeroDayFishCount
    fishTracker[6] += zeroDayFishCount
  }

  return fishTracker.reduce((a, b) => a + b)
}

const printFishTracker = (fishTracker: number[]): string => {
  let printString = ""
  fishTracker.forEach((value, index) => (printString += `Fish on day ${index} count: ${value}\n`))
  return printString
}

export const calculatePart1 = (inputString: string): number => {
  return calculateFish(inputString, 80)
}

export const calculatePart2 = (inputString: string): number => {
  return calculateFish(inputString, 256)
}
