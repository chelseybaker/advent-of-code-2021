export const calculatePositionPart1 = (input: string): number => {
  const steps = input.split("\n")
  let horizontal = 0
  let depth = 0

  steps.forEach((d) => {
    const [direction, amount] = d.split(" ")

    if (direction === "forward") horizontal += parseInt(amount)
    if (direction === "down") depth += parseInt(amount)
    if (direction === "up") depth -= parseInt(amount)
  })

  return horizontal * depth
}

export const calculatePositionPart2 = (input: string): number => {
  const steps = input.split("\n")
  let horizontal = 0
  let depth = 0
  let aim = 0

  steps.forEach((d) => {
    const [direction, stringAmount] = d.split(" ")
    const amount = parseInt(stringAmount)

    if (direction === "down") aim += amount
    if (direction === "up") aim -= amount
    if (direction === "forward") {
      horizontal += amount
      depth += aim * amount
    }
  })

  return horizontal * depth
}
