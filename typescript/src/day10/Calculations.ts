import _ from "lodash"

const closerOpenDelimiters: {[closer: string]: string} = {
  ")": "(",
  "]": "[",
  "}": "{",
  ">": "<",
}

const openingCharacters = ["(", "[", "{", "<"]

export const calculatePart1 = (inputString: string): number => {
  const input = inputString.split("\n")

  let totalCount = 0

  input.forEach((line) => {
    let stack: string[] = []
    let incorrectFound = false
    line.split("").forEach((character, index) => {
      if (incorrectFound) return
      if (openingCharacters.includes(character)) {
        stack.push(character)
        return
      }

      const lastCharacterInStack = _.last(stack)
      if (lastCharacterInStack === closerOpenDelimiters[character]) {
        stack.pop()
        return
      }

      if (lastCharacterInStack && lastCharacterInStack !== closerOpenDelimiters[character]) {
        incorrectFound = true
        if (character === ")") totalCount += 3
        if (character === "]") totalCount += 57
        if (character === "}") totalCount += 1197
        if (character === ">") totalCount += 25137
      }
    })
  })

  return totalCount
}

export const calculatePart2 = (inputString: string): number => {
  const input = inputString.split("\n")

  let totalScores: number[] = []

  input.forEach((line) => {
    let stack: string[] = []
    let incorrectFound = false
    line.split("").forEach((character, index) => {
      if (incorrectFound) return
      if (openingCharacters.includes(character)) {
        stack.push(character)
        return
      }
      const lastCharacterInStack = _.last(stack)
      if (lastCharacterInStack === closerOpenDelimiters[character]) {
        stack.pop()
        return
      }

      if (lastCharacterInStack && lastCharacterInStack !== closerOpenDelimiters[character]) {
        incorrectFound = true
      }
    })

    if (incorrectFound) return
    let newScore = 0

    stack.reverse().forEach((character) => {
      if (character === "(") newScore = newScore * 5 + 1
      if (character === "[") newScore = newScore * 5 + 2
      if (character === "{") newScore = newScore * 5 + 3
      if (character === "<") newScore = newScore * 5 + 4
    })
    totalScores.push(newScore)
  })

  let sortedScores = totalScores.sort((a, b) => a - b)

  return sortedScores[Math.floor(totalScores.length / 2)]
}
