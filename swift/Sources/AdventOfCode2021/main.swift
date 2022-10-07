//
//  File.swift
//  
//
//  Created by Detroit Labs on 10/6/22.
//

import Foundation
import Helpers

func printDay(day: DayCalculatable, input: String) {
  let day01Part01Answer = try? day.calculatePart1(inputString: input)
  let day01Part02Answer = try? day.calculatePart2(inputString: input)
  print("Day 01 Part 1 - \(day01Part01Answer!)")
  print("Day 01 Part 2 - \(day01Part02Answer!)")
  print("--------------")
}

let day01Part01Answer = try? Day01Calculations().calculatePart1(inputString: Day01.Input)
let day01Part02Answer = try? Day01Calculations().calculatePart2(inputString: Day01.Input)
print("Day 01 Part 1 - \(day01Part01Answer!)")
print("Day 01 Part 2 - \(day01Part02Answer!)")
print("--------------")
