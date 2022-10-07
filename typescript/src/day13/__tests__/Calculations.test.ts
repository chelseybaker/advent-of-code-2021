import {calculatePart1, calculatePart2} from "../Calculations"
import Practice from "../Practice"
import Input from "../Input"

describe("DayXX tests", () => {
  describe("Part 1", () => {
    it("should calculate the practice", () => {
      expect(calculatePart1(Practice)).toEqual(17)
    })

    it("should calculate the input", () => {
      expect(calculatePart1(Input)).toEqual(602)
    })
  })

  describe("Part 2", () => {
    it("should calculate the practice", () => {
      expect(calculatePart2(Practice)).toEqual(`#####
#   #
#   #
#   #
#####`)
    })

    it("should calculate the input", () => {
      // CAFJHZCK
      expect(calculatePart2(Input)).toEqual(` #### 
#    #
#    #
 #  # 
      
 #####
#  #  
#  #  
 #####
      
######
# #   
# #   
#     
      
    # 
     #
#    #
##### 
      
######
  #   
  #   
######
      
#   ##
#  # #
# #  #
##   #
      
 #### 
#    #
#    #
 #  # 
      
######
  #   
 # ## 
#    #`)
    })
  })
})
