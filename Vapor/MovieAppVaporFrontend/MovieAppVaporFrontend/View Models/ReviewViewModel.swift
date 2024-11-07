//
//  ReviewViewModel.swift
//  MovieAppVaporFrontend
//
//  Created by Mamadou Balde on 11/7/24.
//

import Foundation
import Combine

class ReviewViewModel: ObservableObject {
  @Published var reviews: [Review] = []
  private var cancellables = Set<AnyCancellable>()
  private let apiService = APIService()
  
  func fetchReviews(for movieID: UUID) {
    apiService.fetchReviews(for: movieID)
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
          break
        case .failure(let error):
          print("Error fetching reviews: \(error)")
        }
      }, receiveValue: { [weak self] reviews in
        self?.reviews = reviews
      })
    
  }
}
