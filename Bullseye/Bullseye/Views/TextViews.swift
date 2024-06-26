//
//  TextViews.swift
//  Bullseye
//
//  Created by Mamadou Balde on 6/4/24.
//

import SwiftUI

struct InstructionText: View {
  var text: String
  
  var body: some View {
    Text(text.uppercased())
      .bold()
      .multilineTextAlignment(.center)
      .lineSpacing(4.0)
      .font(.footnote)
      .kerning(2.0)
      .foregroundColor(Color("TextColor"))
  }
}

struct BigNumberText: View {
  var text: String
  
  var body: some View {
    Text(text)
      .kerning(-1)
      .font(.largeTitle)
      .fontWeight(.black)
      .foregroundStyle(Color("TextColor"))
  }
}

struct SliderLabelText: View {
  var text: String
  
  var body: some View {
    Text(text)
      .kerning(1.5)
      .font(.caption)
      .bold()
      .foregroundColor(Color("TextColor"))
  }
}

struct LabelText: View {
  var text: String
  
  var body: some View {
    Text(text.uppercased())
      .kerning(1.5)
      .font(.caption)
      .bold()
      .foregroundColor(Color("TextColor"))
  }
}

struct BodyText: View {
  var text: String
  
  var body: some View {
    Text(text)
      .font(.subheadline)
      .fontWeight(.semibold)
      .multilineTextAlignment(.center)
      .lineSpacing(10)
  }
}

struct ButtonText: View {
  var text: String
  
  var body: some View {
    Text(text)
      .bold()
      .padding()
      .frame(maxWidth: .infinity)
      .cornerRadius(12)
      .background(
        Color.accentColor
      )
      .foregroundColor(.white)
  }
}

struct ScoreText: View {
  var score: Int
  
  var body: some View {
    Text(String(score))
      .bold()
      .kerning(-0.2)
      .foregroundColor(Color("TextColor"))
      .font(.title3)
  }
}

struct DateText: View {
  var date: Date
  
  var body: some View {
    Text(date, style: .time)
      .bold()
      .kerning(-0.2)
      .foregroundColor(Color("TextColor"))
      .font(.title3)
  }
}

struct BigBoldText: View {
  let text: String
  
  var body: some View {
    Text(text.uppercased())
      .kerning(2.0)
      .foregroundColor(Color("TextColor"))
      .font(.title)
      .fontWeight(.black)
  }
}

#Preview {
  VStack {
    InstructionText(text: "Instructions")
    BigNumberText(text: "999")
    SliderLabelText(text: "99")
    LabelText(text: "Score")
    BodyText(text: "You scored 200 Points\n 😻😻😻")
    ButtonText(text: "Start New Round")
    ScoreText(score: 459)
    DateText(date: Date())
    BigBoldText(text: "Leaderboard")
  }
  .padding()
}

