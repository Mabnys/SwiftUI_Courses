/// Copyright (c) 2023 Kodeco Inc.
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

struct ContentView: View {
  @State var artworks = artData
  @State private var hideVisited = false

  var showArt: [Artwork] {
    hideVisited ? artworks.filter { $0.reaction.isEmpty } : artworks
  }

  var body: some View {
    NavigationStack {
      List(showArt) { artwork in
        NavigationLink(value: artwork) {
          Text("\(artwork.reaction) \(artwork.title)")
            .onAppear { artwork.load() }
            .contextMenu {
              Button("Love it: 💕") {
                self.setReaction("💕", for: artwork)
              }
              Button("Thoughtful: 🙏") {
                self.setReaction("🙏", for: artwork)
              }
              Button("Wow!: 🌟") {
                self.setReaction("🌟", for: artwork)
              }
            }
        }
      }
      .navigationDestination(for: Artwork.self, destination: { artwork in
        DetailView(artwork: artwork)
      })
      .navigationBarTitle("Artworks")
      .navigationBarItems(
        trailing: Toggle(isOn: $hideVisited) { Text("Hide Visited") })
    }
  }

  private func setReaction(_ reaction: String, for item: Artwork) {
    self.artworks = artworks.map { artwork in
      guard artwork.id == item.id else { return artwork }
      let updateArtwork = Artwork(
        artist: item.artist,
        description: item.description,
        locationName: item.locationName,
        discipline: item.discipline,
        title: item.title,
        imageName: item.imageName,
        coordinate: item.coordinate,
        reaction: reaction
      )
      return updateArtwork
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
