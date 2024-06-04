//
//  BackgroundView.swift
//  Bullseye
//
//  Created by Mamadou Balde on 6/4/24.
//

import SwiftUI

struct BackgroundView: View {
  @Binding var game: Game
  
  var body: some View {
    VStack {
      TopView(game: $game)
      Spacer()
      BottomView(game: $game)
    }
    .padding()
    .background(
      Color("BackgroundColor")
        .ignoresSafeArea()
    )
  }
}

struct TopView: View {
  @Binding var game: Game
  
  var body: some View {
    HStack(spacing: 10) {
      RoundedImageViewStroked(systemName: "arrow.counterclockwise")
      Spacer()
      RoundedImageViewFilled(systemName: "list.dash")

    }
  }
}

struct BottomView: View {
  @Binding var game: Game
  
  var body: some View {
    HStack(spacing: 10) {
      NumberView(title: "Score", text: String(game.score))
      Spacer()
      NumberView(title: "Round", text: String(game.round))

    }
  }
}
                                                                     
struct NumberView: View {
  var title: String
  var text: String
  
  var body: some View {
    Color.gray
      .frame(width: 56, height: 56)
  }
}

#Preview {
  BackgroundView(game: .constant(Game()))
}
