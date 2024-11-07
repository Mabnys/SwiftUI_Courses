//
//  ReviewListView.swift
//  MovieAppVaporFrontend
//
//  Created by Mamadou Balde on 11/7/24.
//

import SwiftUI

struct ReviewListView: View {
  let movieID: UUID
      @StateObject private var reviewViewModel = ReviewViewModel()
      
      var body: some View {
          VStack(alignment: .leading) {
              Text("Reviews")
                  .font(.title2)
                  .padding(.top)
              
              ForEach(reviewViewModel.reviews) { review in
                  ReviewRowView(review: review)
              }
          }
          .onAppear {
              reviewViewModel.fetchReviews(for: movieID)
          }
      }
}

#Preview {
    ReviewListView(movieID: UUID())
}
