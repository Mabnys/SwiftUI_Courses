//
//  ContentView.swift
//  CalculatorSwiftUI
//
//  Created by Mamadou Balde on 12/29/23.
//

import SwiftUI

struct ContentView: View {
    let buttons = [
        ["7", "8", "9", "X"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["0", ".", ".", "="]
    ]
    var body: some View {
        ZStack (alignment: .bottom) {
            Color.black.ignoresSafeArea(.all)
            VStack (spacing: 12){
                HStack {
                    Spacer()
                    Text("44")
                        .foregroundStyle(.white)
                        .font(.system(size: 64))
                }
                .padding()
                ForEach(buttons, id: \.self) { row in
                    HStack (spacing: 12) {
                        ForEach(row, id: \.self) { button in
                            Text(button)
                                 .font(.system(size: 32))
                                 .frame(width: buttomWidth(), height: buttomWidth())
                                 .foregroundColor(.white)
                                 .background(Color.yellow)
                                 .cornerRadius(buttomWidth())
                        }
                    }
                }
            }
            .padding(.bottom)
        }
    }
    
    func buttomWidth() -> CGFloat {
        (UIScreen.main.bounds.width - 5 * 12) / 4
    }
}

#Preview {
    ContentView()
}
