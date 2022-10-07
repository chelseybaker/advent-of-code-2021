import _ from "lodash"

type CodeDict = {[key: string]: string}
type LetterCount = {[key: string]: number}

export const splitStringIntoPairs = (inputString: string): string[] => {
  const pairs: string[] = []
  inputString.split("").forEach((v, index) => {
    if (index === inputString.length - 1) return
    pairs.push(v + inputString[index + 1])
  })
  return pairs
}

const calculateCount = (inputString: string, numberOfSteps: number): number => {
  const [initialStringInput, codeInputs] = inputString.split("\n\n")

  const codeDict: CodeDict = {}

  codeInputs.split("\n").forEach((codeLine) => {
    const [key, letter] = codeLine.split(" -> ")
    codeDict[key] = letter
  })

  const initialLetters = initialStringInput.split("")

  const letterCounts: LetterCount = {}
  initialLetters.forEach((letter) => {
    _.isUndefined(letterCounts[letter]) ? (letterCounts[letter] = 1) : (letterCounts[letter] += 1)
  })

  const initialPairs = splitStringIntoPairs(initialStringInput)

  initialPairs.forEach((pair) => {
    const newLetterCount = traverseTree(pair, numberOfSteps - 1, codeDict) // 1 steps left is step 2 in the thingy
    Object.keys(newLetterCount).forEach((key) => {
      _.isUndefined(letterCounts[key])
        ? (letterCounts[key] = newLetterCount[key])
        : (letterCounts[key] += newLetterCount[key])
    })
  })

  let max: number | undefined
  let min: number | undefined

  Object.keys(letterCounts).forEach((key) => {
    if (_.isUndefined(max) || letterCounts[key] > max) max = letterCounts[key]
    if (_.isUndefined(min) || letterCounts[key] < min) min = letterCounts[key]
  })

  traverseTree.cache.clear?.()
  return (max as number) - (min as number)
}

const traverseTree = _.memoize(
  (pair: string, stepsLeft: number, codeDict: CodeDict): LetterCount => {
    const letterCounts: LetterCount = {}
    const letterToInsert = codeDict[pair]
    if (!letterToInsert) return letterCounts
    _.isUndefined(letterCounts[letterToInsert])
      ? (letterCounts[letterToInsert] = 1)
      : (letterCounts[letterToInsert] += 1)

    if (stepsLeft === 0 || pair.length !== 2) return letterCounts

    const splitPair = pair.split("")
    const newString = `${splitPair[0]}${letterToInsert}${splitPair[1]}`
    const newPairs = splitStringIntoPairs(newString)
    newPairs.forEach((pair) => {
      const newLetterCount = traverseTree(pair, stepsLeft - 1, codeDict)
      Object.keys(newLetterCount).forEach((key) => {
        _.isUndefined(letterCounts[key])
          ? (letterCounts[key] = newLetterCount[key])
          : (letterCounts[key] += newLetterCount[key])
      })
    })

    return letterCounts
  },
  (pair, stepsLeft) => `${pair}-${stepsLeft}`
)

export const calculatePart1 = (inputString: string): number => calculateCount(inputString, 10)
export const calculatePart2 = (inputString: string): number => calculateCount(inputString, 40)
