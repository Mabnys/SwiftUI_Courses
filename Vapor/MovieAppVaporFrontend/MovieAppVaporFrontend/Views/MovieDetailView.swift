//
//  MovieDetailView.swift
//  MovieAppVaporFrontend
//
//  Created by Mamadou Balde on 11/7/24.
//

import SwiftUI

struct MovieDetailView: View {
  let movie: Movie
  @StateObject private var reviewViewModel = ReviewViewModel()
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 10) {
        Text(movie.title)
          .font(.title)
        Text("Release Date: \(movie.releaseDate)")
          .font(.subheadline)
        Text("Rating: \(movie.voteAverage, specifier: "%.1f")")
          .font(.subheadline)
        Text(movie.overview)
          .padding(.top)
        
        ReviewListView(movieID: movie.id ?? UUID())
      }
      .padding()
    }
    .navigationTitle("Movie Details")
  }
}


#Preview {
  MovieDetailView(movie: Movie(id: UUID(), tmdbId: 1, title: "Sample Movie", overview: "This is a sample movie with a longer description to test how it looks in the detail view.", releaseDate: "2023-01-01", voteAverage: 8.5))
}
