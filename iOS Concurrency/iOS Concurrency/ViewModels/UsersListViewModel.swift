//
//  UsersListViewModel.swift
//  iOS Concurrency
//
//  Created by Mamadou Balde on 1/10/24.
//

import Foundation

class UsersListViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var errorMessage: String?
    
    func fetchUsers() {
        let apiService = APIService(urlString: "https://jsonplaceholder.typicode.com/users")
        isLoading.toggle() // true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // This could be removed. It's just for testing purposes
            apiService.getJSON { (result: Result<[User], APIError>) in
                defer {
                    DispatchQueue.main.async { // we're using it because isLoading is on a background thread and we're using a published property
                        self.isLoading.toggle() // false
                    }
                }
                switch result {
                case .success(let users):
                    DispatchQueue.main.async {
                        self.users = users
                    }
                case .failure(let error):
//                    print(error)
                    DispatchQueue.main.async {
                        self.showAlert = true
                        self.errorMessage = error.localizedDescription + "\nPlease contact the developer and provide this error and the steps to reproduce."
                    }
                }
            }
        }
    }
}

extension UsersListViewModel {
    convenience init(forPreview: Bool = false) {
        self.init()
        if forPreview {
            self.users = User.mockUsers
        }
    }
}
