import _ from "lodash"

export type Node = {
  value: number
  tentativeDistance: number
  visited: boolean
  x: number
  y: number
}

const getNeighbors = _.memoize(
  (matrix: Node[][], currentNode: Node): Node[] => {
    const nodes: Node[] = []
    if (!_.isUndefined(matrix[currentNode.x + 1]) && !_.isUndefined(matrix[currentNode.x + 1][currentNode.y]))
      nodes.push(matrix[currentNode.x + 1][currentNode.y])
    if (!_.isUndefined(matrix[currentNode.x - 1]) && !_.isUndefined(matrix[currentNode.x - 1][currentNode.y]))
      nodes.push(matrix[currentNode.x - 1][currentNode.y])
    if (!_.isUndefined(matrix[currentNode.x][currentNode.y + 1])) nodes.push(matrix[currentNode.x][currentNode.y + 1])
    if (!_.isUndefined(matrix[currentNode.x][currentNode.y - 1])) nodes.push(matrix[currentNode.x][currentNode.y - 1])
    return nodes
  },
  (matrix, currentNode) => `${JSON.stringify(currentNode)}`
)

export const createMatrix = (inputString: string): Node[][] => {
  return inputString
    .split("\n")
    .map((row, x) =>
      row
        .split("")
        .map((v, y) => ({value: _.parseInt(v), tentativeDistance: Number.MAX_SAFE_INTEGER, visited: false, x: x, y: y}))
    )
}

const calculateShortestPath = (matrix: Node[][]): number => {
  // Mark each of its direct neighbors and update their shortest path to start
  // Mark the current node as visited and remove it from the set
  // (don't need to remove from the matrix, just mark as visited and skip in any traversing)
  // When the destination node has been marked visited, then stop. The algorithm has finished.
  // Otherwise, select the unvisited node that is marked with the smallest tentative distance, set it as the new
  // current node, and go back to step 3.

  /**
   *
   * 1. Mark all nodes unvisited. Create a set of all the unvisited nodes called the unvisited set.
   * 2. Assign to every node a tentative distance value: set it to zero for our initial node and to infinity for all other nodes.
   *    The tentative distance of a node v is the length of the shortest path discovered so far between the node v and
   *    the starting node. Since initially no path is known to any other vertex than the source itself (which is a
   *    path of length zero), all other tentative distances are initially set to infinity. Set the initial node as current.[15]
   * 3. For the current node, consider all of its unvisited neighbors and calculate their tentative distances through
   *    the current node. Compare the newly calculated tentative distance to the current assigned value and assign
   *    the smaller one. For example, if the current node A is marked with a distance of 6, and the edge connecting it
   *    with a neighbor B has length 2, then the distance to B through A will be 6 + 2 = 8. If B was previously marked
   *    with a distance greater than 8 then change it to 8. Otherwise, the current value will be kept.
   * 4. When we are done considering all of the unvisited neighbors of the current node, mark the current node as visited
   *    and remove it from the unvisited set. A visited node will never be checked again.
   * 5. If the destination node has been marked visited (when planning a route between two specific nodes) or if the
   *    smallest tentative distance among the nodes in the unvisited set is infinity (when planning a complete
   *    traversal; occurs when there is no connection between the initial node and remaining unvisited nodes), then stop.
   *    The algorithm has finished.
   * 6. Otherwise, select the unvisited node that is marked with the smallest tentative distance, set it as the new
   *    current node, and go back to step 3.
   */

  let xMax = matrix.length - 1
  let yMax = matrix[xMax].length - 1

  // 1. All nodes were marked visited in createBigMatrix
  // 2. Set the initial node as current.
  let currentNode: Node | undefined = matrix[0][0]

  currentNode.tentativeDistance = 0
  let unvisited = matrix.flat()

  while (currentNode) {
    let neighbors = getNeighbors(matrix, currentNode).filter((n) => !n.visited)
    neighbors.forEach((node) => {
      // Step 3
      node.tentativeDistance = _.min([
        node.tentativeDistance,
        node.value + (currentNode as Node).tentativeDistance,
      ]) as number
    })
    // Step 4
    currentNode.visited = true
    _.remove(unvisited, currentNode)
    // Step 5
    if (matrix[xMax][yMax].visited) {
      currentNode = undefined
    } else {
      currentNode = _.head(_.sortBy(unvisited, "tentativeDistance"))
    }
  }

  return matrix[xMax][yMax].tentativeDistance
}

export const calculatePart1 = (inputString: string): number => {
  const matrix: Node[][] = createMatrix(inputString)

  return calculateShortestPath(matrix)
}

export const calculatePart2 = (inputString: string): number => {
  let newMatrix: Node[][] = createBigMatrix(inputString)

  return calculateShortestPath(newMatrix)
}

export const createBigMatrix = (inputString: string): Node[][] => {
  const matrix: Node[][] = createMatrix(inputString)

  let newMatrix: Node[][] = []
  for (let x = 0; x < matrix.length * 5; x++) {
    newMatrix[x] = []
    for (let y = 0; y < matrix.length * 5; y++) {
      // Determine quadrant, i think it's some x +
      const distance = Math.floor(Math.floor(x / matrix.length) + Math.floor(y / matrix.length))
      const newValue = distance + matrix[x % matrix.length][y % matrix.length].value
      const newNewValue = newValue > 9 ? newValue - 9 : newValue
      newMatrix[x].push({x: x, y: y, visited: false, tentativeDistance: Number.MAX_SAFE_INTEGER, value: newNewValue})
    }
  }
  return newMatrix
}
export const printMatrix = (matrix: Node[][]) => matrix.map((row) => row.map((num) => num.value).join("")).join("\n")
