import _ from "lodash"
import Part1Input from "./Part1Input"

type Square = {
  marked: boolean
  value: number
}

type Board = {
  squares: Square[]
}

export const convertBoard = (inputString: string): Board => {
  const rows = inputString
    .split("\n")
    .map((v) => v.split(" "))
    .flat()
    .filter((v) => !!v)
    .map((v) => ({marked: false, value: parseInt(v)}))
  return {squares: rows}
}

export const calculatePart2 = (inputString: string): number => {
  const input = inputString.split("\n\n")
  const bingoNumbers = input[0].split(",").map((i) => parseInt(i))

  const boards: Board[] = []

  const winningBoardIndices: number[] = []

  for (let i = 1; i < input.length; i++) {
    boards.push(convertBoard(input[i]))
  }

  let lastWinningNum = -1
  bingoNumbers.forEach((bingoNum) => {
    if (winningBoardIndices.length === boards.length) return
    boards.forEach((board) => {
      board.squares.forEach((square) => {
        if (square.value === bingoNum) {
          square.marked = true
        }
      })
    })

    boards.forEach((board, index) => {
      if (!winningBoardIndices.includes(index) && calculateIfBoardHasBingo(board)) {
        winningBoardIndices.push(index)
        lastWinningNum = bingoNum
      }
    })
  })

  const lastIndex = _.last(winningBoardIndices) ?? -1

  const reducer = (previousValue: number, currentValue: number) => previousValue + currentValue

  const board = boards[lastIndex]
  const unmarkedSum = board.squares
    .filter((v) => !v.marked)
    .map((v) => v.value)
    .reduce(reducer)

  return unmarkedSum * lastWinningNum
}

// Apparently I broke this
export const calculatePart1 = (inputString: string): number => {
  const input = inputString.split("\n\n")
  const bingoNumbers = input[0].split(",").map((i) => parseInt(i))

  const boards: Board[] = []

  for (let i = 1; i < input.length; i++) {
    boards.push(convertBoard(input[i]))
  }

  let answer: number | undefined = undefined
  bingoNumbers.forEach((bingoNum) => {
    if (answer) return
    boards.forEach((board) => {
      board.squares.forEach((square, index) => {
        if (square.value === bingoNum) {
          // console.log(`Marking square ${index} on board ${index} for ${bingoNum}`)
          square.marked = true
        }
      })
    })

    const bingoBoard = _.head(boards.filter((board) => calculateIfBoardHasBingo(board)))
    if (bingoBoard) {
      const reducer = (previousValue: number, currentValue: number) => previousValue + currentValue
      const unmarkedSum = bingoBoard.squares
        .filter((v) => !v.marked)
        .map((v) => v.value)
        .reduce(reducer, 0)
      answer = unmarkedSum * bingoNum
    }
  })
  return answer || 0
}

// const printBoard = (board: Board): void => {
//   for (let i = 0; i < board.squares.length; i += 5) {
//     const formatSquare = (square: Square): string => {
//       if (square.marked) return "  X"
//       if (square.value > 9) return " " + square.value.toString()
//       return "  " + square.value.toString()
//     }
//
//     const stringToPrint =
//       formatSquare(board.squares[i]) +
//       formatSquare(board.squares[i + 1]) +
//       formatSquare(board.squares[i + 2]) +
//       formatSquare(board.squares[i + 3]) +
//       formatSquare(board.squares[i + 4]) +
//       "\n"
//
//     console.log(stringToPrint)
//   }
// }

export const calculateIfBoardHasBingo = (board: Board): boolean => {
  if (board.squares.filter((s) => s.marked).length < 5) return false

  // Rows
  for (let i = 0; i < board.squares.length; i += 5) {
    const row = [
      board.squares[i],
      board.squares[i + 1],
      board.squares[i + 2],
      board.squares[i + 3],
      board.squares[i + 4],
    ]
    if (row.filter((square) => square.marked).length === 5) return true
  }

  // Columns
  for (let i = 0; i < 5; i++) {
    const column = [
      board.squares[i],
      board.squares[i + 5],
      board.squares[i + 10],
      board.squares[i + 15],
      board.squares[i + 20],
    ]
    if (column.filter((square) => square.marked).length === 5) return true
  }
  return false
}
