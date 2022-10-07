export const calculatePart1 = (inputString: string): number => {
  const input = inputString.split("\n")
  if (input.length === 0) return 0
  const bitLength = input[0].length

  let gammaRay = ""
  let epsilon = ""

  for (let i = 0; i < bitLength; i++) {
    let zeroCount = 0
    let oneCount = 0

    input.forEach((bits) => {
      if (bits[i] === "1") oneCount++
      if (bits[i] === "0") zeroCount++
    })

    gammaRay += oneCount > zeroCount ? "1" : "0"
    epsilon += oneCount > zeroCount ? "0" : "1"
  }

  return parseInt(gammaRay, 2) * parseInt(epsilon, 2)
}

export const calculatePart2 = (inputString: string): number => {
  const input = inputString.split("\n")
  if (input.length === 0) return 0
  const bitLength = input[0].length

  let oxygenGeneratorRating: string[] = input
  let co2Scrubber: string[] = input

  for (let i = 0; i < bitLength; i++) {
    if (oxygenGeneratorRating.length === 1) continue
    let zeroCount = 0
    let oneCount = 0

    oxygenGeneratorRating.forEach((bits) => {
      if (bits[i] === "1") oneCount++
      if (bits[i] === "0") zeroCount++
    })

    // if it is a 1, keep the number in the input array. So filter
    if (oneCount >= zeroCount) {
      oxygenGeneratorRating = oxygenGeneratorRating.filter((v) => v[i] === "1")
    } else {
      oxygenGeneratorRating = oxygenGeneratorRating.filter((v) => v[i] === "0")
    }
  }

  for (let i = 0; i < bitLength; i++) {
    if (co2Scrubber.length === 1) continue
    let zeroCount = 0
    let oneCount = 0

    co2Scrubber.forEach((bits) => {
      if (bits[i] === "1") oneCount++
      if (bits[i] === "0") zeroCount++
    })

    // if it is a 1, keep the number in the input array. So filter
    if (oneCount < zeroCount) {
      co2Scrubber = co2Scrubber.filter((v) => v[i] === "1")
    } else {
      co2Scrubber = co2Scrubber.filter((v) => v[i] === "0")
    }
  }

  return parseInt(co2Scrubber[0], 2) * parseInt(oxygenGeneratorRating[0], 2)
}
