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
      .bold()
      .foregroundColor(Color("TextColor"))
  }
}

#Preview {
  VStack {
    InstructionText(text: "Instructions")
    BigNumberText(text: "999")
    SliderLabelText(text: "99")
  }
}

