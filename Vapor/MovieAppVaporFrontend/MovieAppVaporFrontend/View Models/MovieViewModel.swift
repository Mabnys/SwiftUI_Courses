//
//  MovieViewModel.swift
//  MovieAppVaporFrontend
//
//  Created by Mamadou Balde on 11/7/24.
//

import Foundation
import Combine

class MovieViewModel: ObservableObject {
  @Published var movies: [Movie] = []
  private var cancellables = Set<AnyCancellable>()
  private let apiService = APIService()
  
  func fetchMovies() {
    apiService.fetchMovies()
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
          break
        case .failure(let error):
          print("Error fetching movies: \(error)")
        }
      }, receiveValue: { [weak self] movies in
        self?.movies = movies
      })
      .store(in: &cancellables)
  }
}
