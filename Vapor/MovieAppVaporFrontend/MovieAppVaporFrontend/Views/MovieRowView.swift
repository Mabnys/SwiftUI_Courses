//
//  MovieRowView.swift
//  MovieAppVaporFrontend
//
//  Created by Mamadou Balde on 11/7/24.
//

import SwiftUI

struct MovieRowView: View {
  let movie: Movie
  
  var body: some View {
    HStack {
      Text(movie.title)
        .font(.headline)
      Spacer()
      Text(String(format: "%.1f", movie.voteAverage))
        .foregroundColor(.secondary)
    }
  }
}

#Preview {
  MovieRowView(movie: Movie(id: UUID(), tmdbId: 1, title: "Sample Movie", overview: "This is a sample movie.", releaseDate: "2023-01-01", voteAverage: 8.5))
}
