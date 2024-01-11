//
//  PostsListViewModel.swift
//  iOS Concurrency
//
//  Created by Mamadou Balde on 1/10/24.
//

import Foundation

class PostsListViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var errorMessage: String?
    var userId: Int?
    
    func fetchPosts() {
        if let userId = userId {
            let apiService = APIService(urlString: "https://jsonplaceholder.typicode.com/users/\(userId)/posts")
            isLoading.toggle()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // This could be removed. It's just for testing purposes
                apiService.getJSON { (result: Result<[Post], APIError>) in
                    defer {
                        DispatchQueue.main.async { // we're using it because isLoading is on a background thread and we're using a published property
                            self.isLoading.toggle() // false
                        }
                    }
                    switch result {
                    case .success(let posts):
                        DispatchQueue.main.async {
                            self.posts = posts
                        }
                    case .failure(let error):
//                        print(error)
                        DispatchQueue.main.async {
                            self.showAlert = true
                            self.errorMessage = error.localizedDescription + "\nPlease contact the developer and provide this error and the steps to reproduce."
                        }
                    }
                }
            }
        }
    }
}

extension PostsListViewModel {
    convenience init(forPreview: Bool = false) {
        self.init()
        if forPreview {
            self.posts = Post.mockSingleUsersPostsArray
        }
    }
}
