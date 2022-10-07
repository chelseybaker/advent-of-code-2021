import _ from "lodash"

/**
 * 0 = 0000
 * 1 = 0001
 * 2 = 0010
 * 3 = 0011
 * 4 = 0100
 * 5 = 0101
 * 6 = 0110
 * 7 = 0111
 * 8 = 1000
 * 9 = 1001
 * A = 1010s
 * B = 1011
 * C = 1100
 * D = 1101
 * E = 1110
 * F = 1111
 */

// Remove the type and version before using this
const calculateLiteral = (inputString: string): string => {
  if (inputString.startsWith("0")) {
    const bits = inputString.slice(1, 5)
    return bits
  }

  const bits = inputString.slice(1, 5)
  return bits + calculateLiteral(inputString.slice(5))
}

const addPacketVersions = (inputString: string) => {
  // the first three bits encode the packet version
  const version = parseInt(inputString.slice(0, 3), 2)

  // the next three bits encode the packet type ID
  const type = parseInt(inputString.slice(3, 6), 2)

  // packets with type ID 4 represent a literal value
  if (type === 4) return parseInt(calculateLiteral(inputString.slice(6)), 2)

  // Every other type of packet (any packet with a type ID other than 4) represent an operator
  // that performs some calculation on one or more sub-packets contained within.
  // If the length type ID is 0, then the next 15 bits are a number that represents the total
  // length in bits of the sub-packets contained by this packet.
  // If the length type ID is 1, then the next 11 bits are a number that represents the number of sub-packets
  // immediately contained by this packet.


}

export const calculatePart1 = (inputString: string): number => addPacketVersions(inputString)
export const calculatePart2 = (inputString: string): number => addPacketVersions(inputString)
