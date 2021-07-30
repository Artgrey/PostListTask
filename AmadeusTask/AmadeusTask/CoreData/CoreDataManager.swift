//
//  CoreDataManager.swift
//  AmadeusTask
//
//  Created by Arturas Krivenkis on 2021-07-04.
//

import UIKit
import CoreData

class CoreDataManager {
    
    static let sharedInstance = CoreDataManager()
    private init(){}
    private var apiManager = ApiManager()
    private var baseController = BaseViewController()
    private let continer: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    private let fetchRequest = NSFetchRequest<Posts>(entityName: "Posts")
    private let fetchRequest2 = NSFetchRequest<Details>(entityName: "Details")
   
    func saveDataOf(posts:[PostsData]) {
        
        self.continer?.performBackgroundTask{ [weak self] (context) in
            self?.deletePostsObjectsfromCoreData(context: context)
            self?.saveDataToCoreData(posts: posts, context: context)
        }
    }
    func saveDetailsDataOf(postsDetails:[PostsDetailsData]) {
        
        self.continer?.performBackgroundTask{ [weak self] (context) in
            self?.deletePostsDetailsObjectsfromCoreData(context: context)
            self?.saveDataToCoreData(postsDetials: postsDetails, context: context)
        }
    }
    private func deletePostsObjectsfromCoreData(context: NSManagedObjectContext) {
        do {
          
            let objects = try context.fetch(fetchRequest)
            _ = objects.map({context.delete($0)})
            try context.save()
        } catch {
            print("Deleting Error: \(error)")
        }
    }
    private func deletePostsDetailsObjectsfromCoreData(context: NSManagedObjectContext) {
        do {
            let objects = try context.fetch(fetchRequest2)
            _ = objects.map({context.delete($0)})
            try context.save()
        } catch {
            print("Deleting Error: \(error)")
        }
    }
 
    private func saveDataToCoreData(posts:[PostsData], context: NSManagedObjectContext) {
       
        context.perform {
            for posts in posts {
                let postsEntity = Posts(context: context)
                postsEntity.title = posts.title
                postsEntity.body = posts.body
                postsEntity.userId = posts.userId!
                postsEntity.id = posts.id!
            }
            do {
                try context.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
        }
    }

    private func saveDataToCoreData(postsDetials:[PostsDetailsData], context: NSManagedObjectContext) {

        context.perform {
            for posts in postsDetials {
                let postsDetailsEntity = Details(context: context)
                postsDetailsEntity.id = posts.id!
                postsDetailsEntity.name = posts.name
                postsDetailsEntity.phone = posts.phone
                postsDetailsEntity.email = posts.email
                postsDetailsEntity.website = posts.website
                postsDetailsEntity.username = posts.username
                
                
                postsDetailsEntity.company = Company(context: context)
                postsDetailsEntity.company?.name = posts.company?.name
                postsDetailsEntity.company?.catchPhrase = posts.company?.catchPhrase
                postsDetailsEntity.company?.bs = posts.company?.bs
                
                postsDetailsEntity.address = Address(context: context)
                postsDetailsEntity.address?.city = posts.address?.city
                postsDetailsEntity.address?.street = posts.address?.street
                postsDetailsEntity.address?.zipcode = posts.address?.zipcode
                postsDetailsEntity.address?.suite = posts.address?.suite
                
                postsDetailsEntity.address?.geo = Geo(context: context)
                postsDetailsEntity.address?.geo?.lat = posts.address?.geo?.lat
                postsDetailsEntity.address?.geo?.lng = posts.address?.geo?.lng
            }
            do {
                try context.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
        }
    }
    func loadPostsData() {
        
        apiManager.getPostsData { [weak self] (result) in
            
            switch result {
            case .success(let listOf):
                self?.saveDataOf(posts: listOf)
                self?.loadPostsDetailsData()
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.baseController.showAlertWith(title: "Could Not Connect!", message: "Please check your internet connection \n or try again later")
                }
                print("Error processing json data: \(error)")
            }
        }
        
    }
    private func loadPostsDetailsData() {
        
        apiManager.getPostsDetailsData { [weak self] (result) in
            
            switch result {
            case .success(let listOf):
            
                self?.saveDetailsDataOf(postsDetails: listOf)
                
            case .failure(let error):
               
                DispatchQueue.main.async {
                    self?.baseController.showAlertWith(title: "Could Not Connect!", message: "Please check your internet connection \n or try again later")
                }
                print("Error processing json data: \(error)")
            }
        }
        
    }
}
