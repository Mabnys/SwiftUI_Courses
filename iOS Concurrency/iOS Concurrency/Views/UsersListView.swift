//
//  UsersListView.swift
//  iOS Concurrency
//
//  Created by Mamadou Balde on 1/10/24.
//

import SwiftUI

struct UsersListView: View {
    #warning("remove the forPreview argument or set it to false before uploading to App Store")
    @StateObject var vm = UsersListViewModel(forPreview: false)
    var body: some View {
        NavigationStack {
            List {
                ForEach(vm.users) { user in
                    NavigationLink {
                        PostsListView(userId: user.id)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(user.name)
                                .font(.title)
                            Text(user.email)
                        }
                    }
                }
            }
            .overlay(content: {
                if vm.isLoading {
                    ProgressView()
                }
            })
            .alert("Application Error", isPresented: $vm.showAlert, actions: {
                Button("OK") {}
            }, message: {
                if let errorMessage = vm.errorMessage {
                    Text(errorMessage)
                }
            })
            .navigationTitle("Users")
            .listStyle(.plain)
            .task {
                // We made onAppear Asynchronous because the func fetchUsers() is one. To do so, we added a Task (an asynchronous unit of work) around the func and await the result. Notice that we don't have any try here because all of the possible errors were caught in the fetchUsers(). Let's combine both onAppear and task by removing .onAppear to only have .task. This is made possible from iOS 15.
                    await vm.fetchUsers()
            }
        }
    }
}

#Preview {
    UsersListView()
}
