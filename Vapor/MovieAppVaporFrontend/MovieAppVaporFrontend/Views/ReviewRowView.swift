//
//  ReviewRowView.swift
//  MovieAppVaporFrontend
//
//  Created by Mamadou Balde on 11/7/24.
//

import SwiftUI

struct ReviewRowView: View {
  let review: Review
  
  var body: some View {
      VStack(alignment: .leading) {
          Text(review.content)
              .font(.body)
          Text("Rating: \(review.rating)")
              .font(.caption)
              .foregroundColor(.secondary)
      }
      .padding(.vertical, 5)
  }
}

#Preview {
    ReviewRowView(review: Review(id: UUID(), content: "This is a sample review.", rating: 4, movieID: UUID()))
}
