import Foundation
import Helpers

class Day23 {
  
  func calculatePart1(inputString: String) throws -> Int {
    throw AoCError.NotYetImplemented
  }
  
  // Did this one by hand 😬
  func calculatePart2(inputString: String) throws -> Int {
    let step1 = """
Start = 0
#############
#...........#
###B#A#A#D###
  #D#C#B#A#
  #D#B#A#C#
  #D#C#B#C#
  #########

Move A 5 = 5
#############
#A..........#
###B#.#A#D###
  #D#C#B#A#
  #D#B#A#C#
  #D#C#B#C#
  #########

Move A 5 = 5
#############
#A.........A#
###B#.#.#D###
  #D#C#B#A#
  #D#B#A#C#
  #D#C#B#C#
  #########

Move B 5 = 50
#############
#A........BA#
###B#.#.#D###
  #D#C#.#A#
  #D#B#A#C#
  #D#C#B#C#
  #########

Move A 7 = 8
#############
#AA.......BA#
###B#.#.#D###
  #D#C#.#A#
  #D#B#.#C#
  #D#C#B#C#
  #########

Move B 5 = 50
#############
#AA.....B.BA#
###B#.#.#D###
  #D#C#.#A#
  #D#B#.#C#
  #D#C#.#C#
  #########

Move C 8 = 800
#############
#AA.....B.BA#
###B#.#.#D###
  #D#.#.#A#
  #D#B#.#C#
  #D#C#C#C#
  #########

Move B 4 = 40
#############
#AA.B...B.BA#
###B#.#.#D###
  #D#.#.#A#
  #D#.#.#C#
  #D#C#C#C#
  #########

Move C 9 = 900
#############
#AA.B...B.BA#
###B#.#.#D###
  #D#.#.#A#
  #D#.#C#C#
  #D#.#C#C#
  #########

Move B 5 = 50
#############
#AA.....B.BA#
###B#.#.#D###
  #D#.#.#A#
  #D#.#C#C#
  #D#B#C#C#
  #########

Move B 6 = 60
#############
#AA.......BA#
###B#.#.#D###
  #D#.#.#A#
  #D#B#C#C#
  #D#B#C#C#
  #########

Move B 7 = 70
#############
#AA........A#
###B#.#.#D###
  #D#B#.#A#
  #D#B#C#C#
  #D#B#C#C#
  #########

Move B 4 = 40
#############
#AA........A#
###.#B#.#D###
  #D#B#.#A#
  #D#B#C#C#
  #D#B#C#C#
  #########

Move D 4 = 4000
#############
#AA...D....A#
###.#B#.#.###
  #D#B#.#A#
  #D#B#C#C#
  #D#B#C#C#
  #########

Move A 3 = 3
#############
#AA...D...AA#
###.#B#.#.###
  #D#B#.#.#
  #D#B#C#C#
  #D#B#C#C#
  #########

Move C 7 = 700
#############
#AA...D...AA#
###.#B#.#.###
  #D#B#C#.#
  #D#B#C#.#
  #D#B#C#C#
  #########

Move C 7 = 700
#############
#AA...D...AA#
###.#B#C#.###
  #D#B#C#.#
  #D#B#C#.#
  #D#B#C#.#
  #########

Move D 7 = 7000
#############
#AA.......AA#
###.#B#C#.###
  #D#B#C#.#
  #D#B#C#.#
  #D#B#C#D#
  #########

Move D 11 = 11000
#############
#AA.......AA#
###.#B#C#.###
  #.#B#C#.#
  #D#B#C#D#
  #D#B#C#D#
  #########

Move D 11 = 11000
#############
#AA.......AA#
###.#B#C#.###
  #.#B#C#D#
  #.#B#C#D#
  #D#B#C#D#
  #########

Move D 11 = 11000
#############
#AA.......AA#
###.#B#C#D###
  #.#B#C#D#
  #.#B#C#D#
  #.#B#C#D#
  #########

Move A 5 = 5
#############
#A........AA#
###.#B#C#D###
  #.#B#C#D#
  #.#B#C#D#
  #A#B#C#D#
  #########

Move A 5 = 5
#############
#.........AA#
###.#B#C#D###
  #.#B#C#D#
  #A#B#C#D#
  #A#B#C#D#
  #########

Move A 9 = 9
#############
#..........A#
###.#B#C#D###
  #A#B#C#D#
  #A#B#C#D#
  #A#B#C#D#
  #########

Move A 9 = 9
#############
#...........#
###A#B#C#D###
  #A#B#C#D#
  #A#B#C#D#
  #A#B#C#D#
  #########

"""
    return 0
  }
}
