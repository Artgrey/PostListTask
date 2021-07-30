//
//  Posts.swift
//  AmadeusTask
//
//  Created by Arturas Krivenkis on 2021-07-20.
//

import Foundation

struct PostsData: Decodable {
    let title: String?
    let body: String?
    let userId: Int64?
    let id: Int64?
   
    private enum CodingKeys: String, CodingKey {
        case title = "title"
        case body = "body"
        case userId = "userId"
        case id = "id"
    }
}
