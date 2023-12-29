//
//  ContentView.swift
//  CalculatorSwiftUI
//
//  Created by Mamadou Balde on 12/29/23.
//

import SwiftUI

enum CalculatorButton: String {
    case zero,  one, two, three, four, five, six, seven, eight, nine
    case equals, plus, minus, multiply, divide
    case decimal
    case ac, plusMinus, percent
    
    var title: String {
        switch self {
        case .zero: return "0"
        case .one: return "1"
        case .two: return "2"
        case .three: return "3"
        case .four: return "4"
        case .five: return "5"
        case .six: return "6"
        case .seven: return "7"
        case .eight: return "8"
        case .nine: return "9"
        case .equals: return "="
        case .plus: return "+"
        case .minus: return "-"
        case .multiply: return "x"
        case .divide: return "/"
        case .decimal: return "."
        case .plusMinus: return "+/-"
        case . percent: return "%"
        default:
            return "AC"
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .decimal:
            return Color(.darkGray)
        case .ac, .plusMinus, .percent:
            return Color(.lightGray)
        default:
            return .orange
        }
    }
}

// Env object
// You can treat this as the Global Application State
class GlobalEnvironment: ObservableObject {
    @Published var display = ""
    
    func receiveInput(calculatorButton: CalculatorButton) {
        self.display = calculatorButton.title
    }
}

struct ContentView: View {
    
    @EnvironmentObject var env: GlobalEnvironment
    
    let buttons: [[CalculatorButton]] = [
        [.ac, .plusMinus, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .minus],
        [.one, .two, .three, .plus],
        [.zero, .decimal, .equals]
       
    ]
    var body: some View {
        ZStack (alignment: .bottom) {
            Color.black.ignoresSafeArea(.all)
            VStack (spacing: 12){
                HStack {
                    Spacer()
                    Text(env.display)
                        .foregroundStyle(.white)
                        .font(.system(size: 64))
                }
                .padding()
                ForEach(buttons, id: \.self) { row in
                    HStack (spacing: 12) {
                        ForEach(row, id: \.self) { button in
                            CalculatorButtonView(button: button)
                        }
                    }
                }
            }
            .padding(.bottom)
        }
    }
}

struct CalculatorButtonView: View {
    
    var button: CalculatorButton
    
    @EnvironmentObject var env: GlobalEnvironment
    
    
    var body: some View {
        Button(action: {
            self.env.receiveInput(calculatorButton: button)
        }) {
            Text(button.title)
                 .font(.system(size: 32))
                 .frame(width: buttomWidth(button: button), height: (UIScreen.main.bounds.width - 5 * 12) / 4)
                 .foregroundColor(.white)
                 .background(button.backgroundColor)
                 .cornerRadius(buttomWidth(button: button))
        }
    }
    
    private func buttomWidth(button: CalculatorButton) -> CGFloat {
        if button == .zero {
            return (UIScreen.main.bounds.width - 4 * 12) / 4 * 2
        }
        return (UIScreen.main.bounds.width - 5 * 12) / 4
    }
}


#Preview {
    ContentView().environmentObject(GlobalEnvironment())
}
