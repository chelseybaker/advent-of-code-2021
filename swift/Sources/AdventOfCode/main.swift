import Foundation
import Helpers

let days: [DayCalculatable] = [Day01Calculations(), Day02Calculations()]

for day in days {
  print(day.summary())
  print("--------------")
}
