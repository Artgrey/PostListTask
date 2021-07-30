//
//  UserPostsController.swift
//  AmadeusTask
//
//  Created by Arturas Krivenkis on 2021-07-04.
//

import UIKit
import CoreData

class UserPostsController: BaseViewController, UpdateTableViewDelegate {
    
    private var apiManager = ApiManager()
    private var postsModel = PostsListViewModel()
    private var postsDetailsModel = DetailsListViewModel()
    let refreshControl = UIRefreshControl()
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableViewSetup()
        self.postsDetailsModel.delegate = self
        retrieveData()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh...")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        table.addSubview(refreshControl)
    }
    private func retrieveData() {
        postsModel.retrieveDataFromCoreData()
        postsDetailsModel.retrieveDataFromCoreData()
    }
    func reloadData(sender: DetailsListViewModel) {
        self.table.reloadData()
    }
    @objc func refresh(_ sender: AnyObject) {
        CoreDataManager.sharedInstance.loadPostsData()
        retrieveData()
        self.table.reloadData()
        self.refreshControl.endRefreshing()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectedPost" {
            guard let detailsVC = segue.destination as? UserDetailsController else {return}
            guard let selectedMovieCell = sender as? UITableViewCell else {return}
            
            if let indexPath = table.indexPath(for: selectedMovieCell) {
                let selectedPost = postsModel.object(indexPath: indexPath)
                detailsVC.postsModel = PostsViewModel(postsInfo: selectedPost)
                
                let selectedPostDetails = postsDetailsModel.object(id: selectedPost!.userId)
                detailsVC.detailsModel = DetailsViewModel(details: selectedPostDetails)
               
            }
        }
    }
}
extension UserPostsController: UITableViewDataSource, UITableViewDelegate {
    private func tableViewSetup() {
        table.dataSource = self
        table.delegate = self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsModel.numberOfRowsInSection(section: section)
    }
    func reloadTableView(){
        DispatchQueue.main.async {
            self.table.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postcell", for: indexPath)  as? PostsListTableViewCell else {
            return UITableViewCell()
        }
        
        let object = postsModel.object(indexPath: indexPath)
        if let post = object {
            let object2 = postsDetailsModel.object(id: post.userId)
            if let detail = object2 {
                cell.setCellWithValuesOf(post, detail)
            }
        }
    
        return cell
    }
}

