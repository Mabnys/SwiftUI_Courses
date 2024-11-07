//
//  ContentView.swift
//  MovieAppVaporFrontend
//
//  Created by Mamadou Balde on 11/7/24.
//

import SwiftUI

struct ContentView: View {
  @StateObject private var movieViewModel = MovieViewModel()
  
  var body: some View {
      NavigationView {
          List(movieViewModel.movies) { movie in
              NavigationLink(destination: MovieDetailView(movie: movie)) {
                  MovieRowView(movie: movie)
              }
          }
          .navigationTitle("Movies")
          .onAppear {
              movieViewModel.fetchMovies()
          }
      }
  }
}

#Preview {
    ContentView()
}
