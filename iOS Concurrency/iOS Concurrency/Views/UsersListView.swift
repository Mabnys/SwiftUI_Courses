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
            .onAppear {
                vm.fetchUsers()
            }
        }
    }
}

#Preview {
    UsersListView()
}
