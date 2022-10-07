import React from "react"
import _ from "lodash"

export const splitLine = (input: string): {x1: number; y1: number; x2: number; y2: number} => {
  const [start, end] = input.split(" -> ")
  const [x1, y1] = start.split(",").map((v) => parseInt(v))
  const [x2, y2] = end.split(",").map((v) => parseInt(v))

  return {x1: x1, y1: y1, x2: x2, y2: y2}
}

type BoardDict = {[name: string]: number}

export const calculatePart1 = (inputString: string): number => {
  const input = inputString.split("\n")
  let finalCount = 0
  let dict: BoardDict = {}

  input.forEach((line) => {
    const values = splitLine(line)

    if (values.x1 === values.x2) {
      const x = values.x1
      const [lowY, highY] = [values.y1, values.y2].sort((y1, y2) => y1 - y2)
      for (let y = lowY; y <= highY; y++) {
        const key = `${x},${y}`
        _.isUndefined(dict[key]) ? (dict[key] = 1) : dict[key]++
        if (dict[key] === 2) finalCount++
      }
    } else if (values.y1 === values.y2) {
      const y = values.y1
      const [lowX, highX] = [values.x1, values.x2].sort((x1, x2) => x1 - x2)
      for (let x = lowX; x <= highX; x++) {
        const key = `${x},${y}`
        _.isUndefined(dict[key]) ? (dict[key] = 1) : dict[key]++
        if (dict[key] === 2) finalCount++
      }
    }
  })

  return finalCount
}

export const calculatePart2 = (inputString: string): number => {
  const input = inputString.split("\n")
  let finalCount = 0
  let dict: BoardDict = {}

  input.forEach((line) => {
    const values = splitLine(line)

    if (values.x1 === values.x2) {
      const x = values.x1
      const [lowY, highY] = [values.y1, values.y2].sort((y1, y2) => y1 - y2)
      for (let y = lowY; y <= highY; y++) {
        const key = `${x},${y}`
        _.isUndefined(dict[key]) ? (dict[key] = 1) : dict[key]++
        if (dict[key] === 2) finalCount++
      }
    } else if (values.y1 === values.y2) {
      const y = values.y1
      const [lowX, highX] = [values.x1, values.x2].sort((x1, x2) => x1 - x2)
      for (let x = lowX; x <= highX; x++) {
        const key = `${x},${y}`
        _.isUndefined(dict[key]) ? (dict[key] = 1) : dict[key]++
        if (dict[key] === 2) finalCount++
      }
    } else if ((values.x1 > values.x2 && values.y1 > values.y2) || (values.x1 < values.x2 && values.y1 < values.y2)) {
      // // diagonal left to right down
      // left to right diagonal
      const [lowX, highX] = [values.x1, values.x2].sort((x1, x2) => x1 - x2)
      const [lowY, highY] = [values.y1, values.y2].sort((y1, y2) => y1 - y2)
      const diff = highX - lowX
      for (let i = 0; i <= diff; i++) {
        const key = `${lowX + i},${lowY + i}`
        _.isUndefined(dict[key]) ? (dict[key] = 1) : dict[key]++
        if (dict[key] === 2) finalCount++
      }
    } else {
      // diagonal left to right up
      const [lowX, highX] = [values.x1, values.x2].sort((x1, x2) => x1 - x2)
      const [lowY, highY] = [values.y1, values.y2].sort((y1, y2) => y1 - y2)
      const diff = highX - lowX

      for (let i = 0; i <= diff; i++) {
        const key = `${lowX + i},${highY - i}`
        _.isUndefined(dict[key]) ? (dict[key] = 1) : dict[key]++
        if (dict[key] === 2) finalCount++
      }
    }
  })
  return finalCount
}

const printDict = (boardDict: BoardDict): string => {
  let printString = ""
  Object.keys(boardDict).forEach((key) => (printString += `${key}: ${boardDict[key]}\n`))
  return printString
}

const printBoard = (boardDict: BoardDict): string => {
  let printString = ""
  for (let y = 0; y < 10; y++) {
    for (let x = 0; x < 10; x++) {
      const key = `${x},${y}`
      printString += _.isUndefined(boardDict[key]) ? "." : boardDict[key]
    }
    printString += "\n"
  }

  return printString
}
