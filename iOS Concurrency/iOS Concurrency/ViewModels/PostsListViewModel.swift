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
    
    @MainActor //This MainActor attribute is used to dispatch the task back onto the main queue
    func fetchPosts() async { // Anytime we have concurrency, we need to specify that our function is asychronous
        if let userId = userId {
            let apiService = APIService(urlString: "https://jsonplaceholder.typicode.com/users/\(userId)/posts")
            isLoading.toggle()
            defer {
                isLoading.toggle() // false
            }
            do {
                posts = try await apiService.getJSON()
            } catch {
                showAlert = true
                errorMessage = error.localizedDescription + "\nPlease contact the developer and provide this error and the steps to reproduce."
            }
            #warning("THIS getJSON func needs to be commented out for now. To be keep for reference")
//            apiService.getJSON { (result: Result<[Post], APIError>) in
//                defer {
//                    DispatchQueue.main.async { // we're using it because isLoading is on a background thread and we're using a published property
//                        self.isLoading.toggle() // false
//                    }
//                }
//                switch result {
//                case .success(let posts):
//                    DispatchQueue.main.async {
//                        self.posts = posts
//                    }
//                case .failure(let error):
//                    DispatchQueue.main.async {
//                        self.showAlert = true
//                        self.errorMessage = error.localizedDescription + "\nPlease contact the developer and provide this error and the steps to reproduce."
//                    }
//                }
//            }
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
