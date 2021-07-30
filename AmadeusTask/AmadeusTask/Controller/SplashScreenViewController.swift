//
//  SplashScreenViewController.swift
//  AmadeusTask
//
//  Created by Arturas Krivenkis on 2021-07-12.
//

import UIKit

class SplashScreenViewController: BaseViewController{
    private var apiManager = ApiManager()
    @IBOutlet var activityIndicator: UIActivityIndicatorView?
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator?.startAnimating()
        loadPostsData()
    }
    func loadPostsData() {
       
        apiManager.getPostsData { [weak self] (result) in
            
            switch result {
            case .success(let listOf):
                CoreDataManager.sharedInstance.saveDataOf(posts: listOf)
                self?.loadPostsDetailsData()
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlertWith(title: "Could Not Connect!", message: "Please check your internet connection \n or try again later")
                }
                
                print("Error processing json data: \(error)")
            }
        }
        
    }
    private func loadPostsDetailsData() {
        
        apiManager.getPostsDetailsData { [weak self] (result) in
            
            switch result {
            case .success(let listOf):
                
                CoreDataManager.sharedInstance.saveDetailsDataOf(postsDetails: listOf)
                self?.perform(#selector(self?.mainScreen))
            case .failure(let error):
              
                DispatchQueue.main.async {
                    self?.showAlertWith(title: "Could Not Connect!", message: "Please check your internet connection \n or try again later")
                }
              
                print("Error processing json data: \(error)")
            }
        }
        
    }
    @objc func mainScreen() {
        activityIndicator?.stopAnimating()
        performSegue(withIdentifier: "moveToPosts", sender: self)
    }
}
