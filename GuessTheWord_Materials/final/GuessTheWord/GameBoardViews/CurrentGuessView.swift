/// Copyright (c) 2022 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.


import SwiftUI

struct CurrentGuessView: View {
  @Binding var guess: Guess
  var wordLength: Int

  var unguessedLetters: Int {
    wordLength - guess.word.count
  }

  var body: some View {
    // 1
    GeometryReader { proxy in
      HStack {
        Spacer()
        // 2
        let width = (proxy.size.width - 40) / 5 * 0.8
        // 3
        ForEach(guess.word.indices, id: \.self) { index in
          // 4
          let letter = guess.word[index]
          GuessBoxView(letter: letter, size: width, index: index)
        }
        // 5
        ForEach(0..<unguessedLetters, id: \.self) { _ in
          EmptyBoxView(size: width)
        }
        Spacer()
      }
      .padding(5.0)
      .overlay(
        Group {
          if guess.status == .invalidWord {
            Text("Word not in dictionary.")
              .foregroundColor(.red)
              .background(Color(UIColor.systemBackground).opacity(0.8))
              .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                  guess.status = .pending
                }
              }
          }
        }
      )
    }
  }
}

struct CurrentGuessView_Previews: PreviewProvider {
  static var previews: some View {
    let guessedLetter = GuessedLetter(letter: "S", status: .inPosition)
    let guessedLetter2 = GuessedLetter(letter: "A", status: .notInPosition)
    let guess = Guess(
      word: [guessedLetter, guessedLetter2],
      status: .pending
    )
    CurrentGuessView(
      guess: .constant(guess),
      wordLength: 5
    )
  }
}
