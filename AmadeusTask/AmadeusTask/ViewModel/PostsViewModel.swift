//
//  PostsViewModel.swift
//  AmadeusTask
//
//  Created by Arturas Krivenkis on 2021-07-14.
//

import Foundation

class PostsViewModel {
    
    let postsInfo: Posts?
    
    let title: String?
    let body: String?
    let id: Int64
    let userId: Int64
    init(postsInfo: Posts?) {
        self.postsInfo = postsInfo

        self.title = postsInfo?.title
        self.body = postsInfo?.body
        self.id = postsInfo?.id ?? 0
        self.userId = postsInfo?.userId ?? 0
    }
}

