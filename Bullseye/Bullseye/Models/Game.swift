//
//  Game.swift
//  Bullseye
//
//  Created by Mamadou Balde on 6/3/24.
//

import Foundation

struct Game {
  var target = Int.random(in: 1...100)
  var score = 0
  var round = 1
  
  func points(sliderValue: Int) -> Int {
    100 - abs(target - sliderValue)
  }
  
  mutating func startNewRound(points: Int) {
    score += points
    round += 1
  }
}
