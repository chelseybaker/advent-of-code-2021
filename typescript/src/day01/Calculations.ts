import {toInteger} from "lodash";

export const calculatePositionPart1 = (input: string): number => {
  const scans = input.split("\n").map(s => toInteger(s))
  let increases = 0

  for (let i = 1; i < scans.length; i++) {
    if (scans[i] > scans[i - 1]) increases++
  }

  return increases
}

export const calculatePositionPart2 = (input: string): number => {
  const scans = input.split("\n").map(s => toInteger(s))
  let slidingWindow: number[] = []

  for (let i = 2; i < scans.length; i++) {
    slidingWindow.push(scans[i] + scans[i - 1] + scans[i - 2])
  }

  let increases = 0
  for (let i = 1; i < slidingWindow.length; i++) {
    if (slidingWindow[i] > slidingWindow[i - 1]) increases++
  }

  return increases
}
