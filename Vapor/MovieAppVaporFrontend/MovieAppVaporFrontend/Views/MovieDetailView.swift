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
        // Movie details section
        Text(movie.title)
          .font(.title)
        Text("Release Date: \(movie.releaseDate)")
          .font(.subheadline)
        Text("Rating: \(movie.voteAverage, specifier: "%.1f")")
          .font(.subheadline)
        Text(movie.overview)
          .padding(.top)
        
        // Reviews section
        Text("Reviews")
          .font(.title2)
          .padding(.top)
        
        // Display reviews or a message if no reviews are available
        if reviewViewModel.isLoading {
          ProgressView() // Show loading indicator while fetching reviews
        } else if reviewViewModel.reviews.isEmpty {
          Text("No reviews yet.")
            .foregroundColor(.secondary)
        } else {
          ForEach(reviewViewModel.reviews) { review in
            ReviewRowView(review: review)
            Divider()
          }
        }
      }
      .padding()
    }
    .navigationBarTitle(Text("\(movie.title)'s Details"), displayMode: .inline)
    .onAppear {
      // Fetch reviews when the view appears
      if let id = movie.id {
        reviewViewModel.fetchReviews(for: id)
      }
    }
  }
}


#Preview {
  // Create a sample movie for the preview
  let sampleMovie = Movie(
    id: UUID(),
    tmdbId: 1,
    title: "Sample Movie",
    overview: "This is a sample movie with a longer description to test how it looks in the detail view.",
    releaseDate: "2023-01-01",
    voteAverage: 8.5
  )
  
  // Create a wrapper view that sets up a mock ReviewViewModel
  return MovieDetailView(movie: sampleMovie)
    .environmentObject(ReviewViewModel()) // Provide a mock ReviewViewModel if needed
}
