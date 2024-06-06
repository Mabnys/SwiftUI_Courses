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
      BackgroundView(game: $game)
      VStack {
        InstructionsView(game: $game)
          .padding(.bottom, alertIsVisible ? 0 : 100)
        if alertIsVisible {
          PointsView(alertIsVisible: $alertIsVisible, sliderValue: $sliderValue, game: $game)
            .transition(.scale)
        } else {
          HitMeButton(alertIsVisible: $alertIsVisible, sliderValue: $sliderValue, game: $game)
            .transition(.scale)
        }
      }
      if !alertIsVisible {
        SliderView(sliderValue: $sliderValue)
          .zIndex(1)
          .transition(.scale)
      }
    }
  }
}

struct InstructionsView: View {
  @Binding var game: Game
  
  var body: some View {
    VStack {
      InstructionText(text: "🎯🎯🎯\n Put the bullseye as close as you can to")
        .padding(.horizontal, 30)
      BigNumberText(text: String(game.target))
    }
  }
}

struct SliderView: View {
  @Binding var sliderValue: Double
  
  var body: some View {
    HStack {
      SliderLabelText(text: "1")
        .frame(width: 35)
      Slider(value: $sliderValue, in: 1.0...100.0)
        .onAppear {
          let renderer = ImageRenderer(
            content: Image(systemName: "target")
              .foregroundColor(.red)
              .font(.largeTitle)
              .background(Color("BackgroundColor"))
          )
          if let thumbImage = renderer.uiImage {
            UISlider.appearance().setThumbImage(thumbImage, for: .normal)
          }
        }
      SliderLabelText(text: "100")
        .frame(width: 35)
    }
    .padding()
  }
}

struct HitMeButton: View {
  @Binding var alertIsVisible: Bool
  @Binding var sliderValue: Double
  @Binding var game: Game
  var body: some View {
    Button("Hit me".uppercased()) {
      withAnimation {
        alertIsVisible = true
      }
    }
    .padding(20.0)
    .background(
      ZStack {
        Color("ButtonColor")
        LinearGradient(colors: [Color.white.opacity(0.3), Color.clear], startPoint: .top, endPoint: .bottom)
      }
    )
    .overlay(
      RoundedRectangle(cornerRadius: Constants.General.roundRectCornerRadius)
        .strokeBorder(Color.white, lineWidth: Constants.General.strokeWidth)
    )
    .foregroundColor(.white)
    .cornerRadius(Constants.General.roundRectCornerRadius)
    .bold()
    .font(.title3)
  }
}

#Preview {
  ContentView()
}
#Preview {
  ContentView()
    .previewInterfaceOrientation(.landscapeRight)
    .preferredColorScheme(.dark)
}
