//
//  PostsListTableViewCell.swift
//  AmadeusTask
//
//  Created by Arturas Krivenkis on 2021-07-14.
//

import UIKit

class PostsListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postBody: UILabel!
    @IBOutlet weak var postId: UILabel!
    @IBOutlet weak var postUserId: UILabel!
    
    private var apiManager = ApiManager()
    private var urlString: String = ""
    
    func setCellWithValuesOf(_ post:Posts, _ details:Details) {
        updateUI(title: post.title, body: post.body, name: details.username, companyName: details.company?.name)
    }
    private func updateUI(title:String?, body:String?, name:String?, companyName:String?) {
        
        self.postTitle.text = title
        self.postBody.text = body
        self.postId.text = name
        self.postUserId.text = companyName
    }

}
