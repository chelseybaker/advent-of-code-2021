import _ from "lodash"
import {start} from "repl"
const Start = "start"
const End = "end"

const isLowercase = (thing: string): boolean => {
  return thing === thing.toLowerCase()
}

export type NodeTree = {[nodeName: string]: string[]}

const createNodeTree = (inputString: string): NodeTree => {
  let nodeDict: NodeTree = {}
  const input = inputString.split("\n")
  input.forEach((node) => {
    const [start, end] = node.split("-")
    _.isUndefined(nodeDict[start]) ? (nodeDict[start] = [end]) : nodeDict[start].push(end)
    _.isUndefined(nodeDict[end]) ? (nodeDict[end] = [start]) : nodeDict[end].push(start)
  })
  return nodeDict
}

const countPathsPart1 = (nodeTree: NodeTree, startingNode: string, traversedNodes: string[]): string[][] => {
  if (startingNode === End) return [[...traversedNodes, End]]

  // If it's the starting node and there's already indicies, return []
  if (startingNode === Start && traversedNodes.includes(Start)) return []

  if (isLowercase(startingNode) && traversedNodes.includes(startingNode)) return []

  const childrenPaths = nodeTree[startingNode].map((nextNode) =>
    countPathsPart1(nodeTree, nextNode, [...traversedNodes, startingNode])
  )
  return childrenPaths.flat().filter((v) => !_.isEmpty(v))
}

export const calculatePart1 = (inputString: string): number => {
  const nodeDict = createNodeTree(inputString)

  const startNodes = nodeDict.start
  if (!startNodes) return 0

  return countPathsPart1(nodeDict, "start", []).length
}

const hasVisitedSmallCaveTwice = (traversedNodes: string[]): boolean => {
  // return true if there are two of the same lowercase caves
  const nodeCount: {[node: string]: number} = {}
  let multipleFound = false
  traversedNodes.forEach((n) => {
    if (isLowercase(n)) {
      nodeCount[n] = _.isUndefined(nodeCount[n]) ? 1 : nodeCount[n] + 1
      if (nodeCount[n] >= 2) multipleFound = true
    }
  })

  return multipleFound
}

const countPathsPart2 = (nodeTree: NodeTree, startingNode: string, traversedNodes: string[]): string[][] => {
  if (startingNode === End) return [[...traversedNodes, End]]

  // If it's the starting node and there's already indicies, return []
  if (startingNode === Start && traversedNodes.includes(Start)) return []

  if (isLowercase(startingNode) && traversedNodes.filter((v) => v === startingNode).length >= 2) return []

  if (
    isLowercase(startingNode) &&
    hasVisitedSmallCaveTwice(traversedNodes) &&
    traversedNodes.filter((v) => v === startingNode).length >= 1
  )
    return []

  const childrenPaths = nodeTree[startingNode].map((nextNode) =>
    countPathsPart2(nodeTree, nextNode, [...traversedNodes, startingNode])
  )
  return childrenPaths.flat().filter((v) => !_.isEmpty(v))
}

export const calculatePart2 = (inputString: string): number => {
  const nodeDict = createNodeTree(inputString)

  const startNodes = nodeDict.start
  if (!startNodes) return 0

  return countPathsPart2(nodeDict, "start", []).length
}
