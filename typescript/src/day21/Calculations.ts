import _ from "lodash"

type Player = {
  score: number
  rollCount: number
  position: number
}

export const calculatePart1 = (inputString: string): number => {
  const [positionOne, positionTwo] = inputString
    .split("\n")
    .map((v) => _.parseInt(_.last(v.split(": ")) as string)) as number[]

  let playerOne: Player = {score: 0, rollCount: 0, position: positionOne}
  let playerTwo: Player = {score: 0, rollCount: 0, position: positionTwo}
  let isOneTurn = true
  let dieNumber = 1
  let rollCount = 0

  // what do you get if you multiply the score of the losing player by the number of times the die was rolled during the game?
  while (playerOne.score < 1000 && playerTwo.score < 1000) {
    const total = generateTotals(dieNumber)

    if (isOneTurn) {
      playerOne = addToPlayer(playerOne, total)
    } else {
      playerTwo = addToPlayer(playerTwo, total)
    }
    rollCount += 3
    isOneTurn = !isOneTurn

    dieNumber = dieNumber += 3
    if (dieNumber > 100) dieNumber = dieNumber - 100
  }

  const winningScore = playerOne.score < 1000 ? playerOne.score : playerTwo.score
  return winningScore * rollCount
}

const generateTotals = (dieNumber: number): number => {
  if (dieNumber < 99) {
    return dieNumber + dieNumber + 1 + dieNumber + 2
  } else if (dieNumber === 99) {
    return 99 + 100 + 1
  } else if (dieNumber === 100) {
    return 100 + 1 + 2
  }
  return 0
}

export const calculatePart2 = (inputString: string): number => {
  const [positionOne, positionTwo] = inputString
    .split("\n")
    .map((v) => _.parseInt(_.last(v.split(": ")) as string)) as number[]

  let playerOne: Player = {score: 0, rollCount: 0, position: positionOne}
  let playerTwo: Player = {score: 0, rollCount: 0, position: positionTwo}

  // what do you get if you multiply the score of the losing player by the number of times the die was rolled during the game?
  const wins = part2Recursion(playerOne, playerTwo, true)

  return _.max([wins.oneWins, wins.twoWins]) as number
}

const part2Recursion = _.memoize(
  (playerOne: Player, playerTwo: Player, isPlayerOneTurn: boolean): {oneWins: number; twoWins: number} => {
    if (playerOne.score >= 21) {
      return {oneWins: 1, twoWins: 0}
    } else if (playerTwo.score >= 21) {
      return {oneWins: 0, twoWins: 1}
    }

    let newWins: {oneWins: number; twoWins: number}[] = []

    for (let x = 1; x <= 3; x++) {
      for (let y = 1; y <= 3; y++) {
        for (let z = 1; z <= 3; z++) {
          const player1 = isPlayerOneTurn ? addToPlayer(playerOne, x + y + z) : _.cloneDeep(playerOne)
          const player2 = !isPlayerOneTurn ? addToPlayer(playerTwo, x + y + z) : _.cloneDeep(playerTwo)
          newWins.push(part2Recursion(player1, player2, !isPlayerOneTurn))
        }
      }
    }

    return reduceWins(newWins)
  },
  (playerOne, playerTwo, isPlayerOneTurn) =>
    `${JSON.stringify(playerOne)}-${JSON.stringify(playerTwo)}-${JSON.stringify(isPlayerOneTurn)}`
)

const reduceWins = _.memoize((newWins: {oneWins: number; twoWins: number}[]): {oneWins: number; twoWins: number} => {
  const wins: {oneWins: number; twoWins: number} = {oneWins: 0, twoWins: 0}
  newWins.forEach((win) => {
    wins.oneWins += win.oneWins
    wins.twoWins += win.twoWins
  })
  return wins
})

const addToPlayer = _.memoize(
  (_player: Player, moveNumber: number): Player => {
    const player = _.cloneDeep(_player)
    player.position = (player.position + moveNumber) % 10
    const addToScore = player.position === 0 ? 10 : player.position
    player.score += addToScore
    return player
  },
  (_player, moveNumber) => `${_player.position}-${_player.score}-${moveNumber}`
)
