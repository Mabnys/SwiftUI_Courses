//
//  ContentView.swift
//  Bullseye
//
//  Created by Mamadou Balde on 6/3/24.
//

import SwiftUI

struct ContentView: View {
  @State private var alertIsVisible: Bool = false
  @State private var sliderValue: Double = 50.0
  @State private var game: Game = Game()
  
  var body: some View {
    VStack {
      Text("🎯🎯🎯\n PUT THE BULLSEYE AS CLOSE AS YOU CAN TO")
        .bold()
        .multilineTextAlignment(.center)
        .lineSpacing(4.0)
        .font(.footnote)
        .kerning(2.0)
      Text(String(game.target))
        .kerning(-1)
        .font(.largeTitle)
        .fontWeight(.black)
      HStack {
        Text("1")
          .bold()
        Slider(value: $sliderValue, in: 1.0...100.0)
        Text("100")
          .bold()
      }
      Button("Hit me") {
        alertIsVisible = true
      }
      .alert("Hello there",
             isPresented: $alertIsVisible,
             actions: {
        Button("Awesome") {
          print("Alert closed")
        }
      },
             message: {
        let roundedValue: Int = Int(sliderValue)
        Text("""
          The slider's value is \(roundedValue).
          You scored \(game.points(sliderValue: roundedValue)) points this round.
          """)
      })
    }
  }
}

#Preview {
  ContentView()
}
