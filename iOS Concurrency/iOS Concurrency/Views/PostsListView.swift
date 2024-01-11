//
//  PostsListView.swift
//  iOS Concurrency
//
//  Created by Mamadou Balde on 1/10/24.
//

import SwiftUI

struct PostsListView: View {
    var posts: [Post]
    var body: some View {
        List {
            ForEach(posts) { post in
                VStack(alignment: .leading) {
                    Text(post.title)
                        .font(.headline)
                    Text(post.body)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("Posts")
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        PostsListView(posts: Post.mockSingleUsersPostsArray)
    }
}
