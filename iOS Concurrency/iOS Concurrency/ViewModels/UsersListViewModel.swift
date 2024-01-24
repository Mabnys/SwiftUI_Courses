//
//  UsersListViewModel.swift
//  iOS Concurrency
//
//  Created by Mamadou Balde on 1/10/24.
//

import Foundation
// Life-cycle Object (reference type, observer)
class UsersListViewModel: ObservableObject {
    // State / Dependencies
    @Published var usersAndPosts: [UserAndPosts] = []
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var errorMessage: String?
    
    @MainActor //This MainActor attribute is used to dispatch the task back onto the main queue
    func fetchUsers() async { // Actions / Task
        let apiService = APIService(urlString: "https://jsonplaceholder.typicode.com/users")
        let apiService2 = APIService(urlString: "https://jsonplaceholder.typicode.com/posts")
        isLoading.toggle() // true
        defer {
            isLoading.toggle() // false
        }
        do {
            async let users: [User] = try await apiService.getJSON()
            async let posts: [Post] = try await apiService2.getJSON()
            let (fetchedUsers, fetchedPosts) = await (try users, try posts)
            for user in fetchedUsers {
                let userPosts = fetchedPosts.filter {$0.userId == user.id}
                let newUserAndPosts = UserAndPosts(user: user, posts: userPosts)
                usersAndPosts.append(newUserAndPosts)
            }
        } catch {
            showAlert = true
            errorMessage = error.localizedDescription + "\nPlease contact the developer and provide this error and the steps to reproduce."
        }
        #warning("THIS getJSON func needs to be commented out for now. To be keep for reference")
//        apiService.getJSON { (result: Result<[User], APIError>) in
//            defer {
//                DispatchQueue.main.async { // we're using it because isLoading is on a background thread and we're using a published property
//                    self.isLoading.toggle() // false
//                }
//            }
//            switch result {
//            case .success(let users):
//                DispatchQueue.main.async {
//                    self.users = users
//                }
//            case .failure(let error):
//                DispatchQueue.main.async {
//                    self.showAlert = true
//                    self.errorMessage = error.localizedDescription + "\nPlease contact the developer and provide this error and the steps to reproduce."
//                }
//            }
//        }
    }
}

extension UsersListViewModel {
    convenience init(forPreview: Bool = false) {
        self.init()
        if forPreview {
            self.usersAndPosts = UserAndPosts.mockUsersAndPosts
        }
    }
}
