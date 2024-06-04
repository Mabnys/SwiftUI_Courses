//
//  ContentView.swift
//  Bullseye
//
//  Created by Mamadou Balde on 6/3/24.
//

import SwiftUI

struct ContentView: View {
  @State private var alertIsVisible = false
  @State private var sliderValue = 50.0
  @State private var game = Game()
  
  var body: some View {
    ZStack {
      Color("BackgroundColor")
        .ignoresSafeArea()
      VStack {
        Text("🎯🎯🎯\n Put the bullseye as close as you can to".uppercased())
          .bold()
          .multilineTextAlignment(.center)
          .lineSpacing(4.0)
          .font(.footnote)
          .kerning(2.0)
          .padding(.horizontal, 30)
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
        .padding()
        Button("Hit me".uppercased()) {
          alertIsVisible = true
        }
        .padding(20.0)
        .background(
          ZStack {
            Color("ButtonColor")
            LinearGradient(colors: [Color.white.opacity(0.3), Color.clear], startPoint: .top, endPoint: .bottom)
          }
        )
        .foregroundColor(.white)
        .cornerRadius(20.0)
        .bold()
        .font(.title3)
        .alert("Hello there",
               isPresented: $alertIsVisible,
               actions: {
          Button("Awesome") {
            print("Alert closed")
          }
        },
               message: {
          let roundedValue = Int(sliderValue)
          Text("""
            The slider's value is \(roundedValue).
            You scored \(game.points(sliderValue: roundedValue)) points this round.
            """)
        })
      }
    }
  }
}

#Preview {
  ContentView()
}
#Preview {
  ContentView()
    .preferredColorScheme(.dark)
    .previewDevice("iPhone 14 Pro Max")
}
