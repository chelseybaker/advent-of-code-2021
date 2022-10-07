import _, {parseInt} from "lodash"

export const calculatePart1 = (inputString: string): number => {
  const input = inputString.split("\n").map((line) => {
    const fullLine = line.split("| ")
    return fullLine[1]
  })

  let count = 0

  input.forEach((line) => {
    const nums = line.split(" ")
    nums.forEach((n) => {
      if (n.length === 2 || n.length === 3 || n.length === 4 || n.length === 7) count++
    })
  })

  return count
}

// Splits the string, sorts it alphabetically, then rejoins the string
const sortPattern = (pattern?: string): string | undefined => pattern?.split("").sort().join("")

// Returns true if all letters of patternB are in patternA
const patternAContainsPatternB = (patternA: string, patternB: string): boolean =>
  _.isEqual(_.union(patternA.split(""), patternB.split("")).sort(), patternA.split("").sort())

const calculateDigit = (line: string): number => {
  const [signalPatternString, outputString] = line.split(" | ")
  const signalPatterns = signalPatternString.split(" ")

  const one = sortPattern(_.head(signalPatterns.filter((d) => d.length === 2)))
  const four = sortPattern(_.head(signalPatterns.filter((d) => d.length === 4)))
  const seven = sortPattern(_.head(signalPatterns.filter((d) => d.length === 3)))
  const eight = sortPattern(_.head(signalPatterns.filter((d) => d.length === 7)))

  if (!eight || !seven || !four || !one) return 0

  let dict: {[key: string]: string} = {}

  while (Object.keys(dict).length < 10) {
    signalPatterns.forEach((unsortedPattern) => {
      const pattern = sortPattern(unsortedPattern)
      if (!pattern) return

      if (pattern === eight) {
        dict[pattern] = "8"
      } else if (pattern === one) {
        dict[pattern] = "1"
      } else if (pattern === seven) {
        dict[pattern] = "7"
      } else if (pattern === four) {
        dict[pattern] = "4"
      } else if (unsortedPattern.length === 6) {
        // 0 6 or 9
        if (patternAContainsPatternB(pattern, four)) {
          dict[pattern] = "9"
        } else if (patternAContainsPatternB(pattern, one)) {
          dict[pattern] = "0"
        } else {
          dict[pattern] = "6"
        }
      } else if (unsortedPattern.length === 5) {
        // 2 3 or 5
        const six = _.findKey(dict, (value) => value === "6")
        if (patternAContainsPatternB(pattern, one)) dict[pattern] = "3"
        else if (!!six) dict[pattern] = patternAContainsPatternB(six, unsortedPattern) ? "5" : "2"
      }
    })
  }

  let digitalString = ""
  outputString.split(" ").forEach((num) => {
    const key = num.split("").sort().join("")
    digitalString += dict[key]
  })

  return parseInt(digitalString)
}

export const calculatePart2 = (inputString: string): number => {
  const input = inputString.split("\n")

  let finalCount = 0

  input.forEach((line) => (finalCount += calculateDigit(line)))

  return finalCount
}
