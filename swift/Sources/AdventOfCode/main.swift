import Foundation
import Helpers

let days: [AoCPrintable] = [Day01(), Day02(), Day16()]

for day in days {
  print(day.summary())
  print("--------------")
}