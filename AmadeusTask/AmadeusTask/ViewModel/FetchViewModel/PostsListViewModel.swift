//
//  PostsListViewModel.swift
//  AmadeusTask
//
//  Created by Arturas Krivenkis on 2021-07-14.
//

import Foundation
import UIKit
import CoreData

class PostsListViewModel: NSObject, NSFetchedResultsControllerDelegate {
    
    private let container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    private var fetchedResultsController: NSFetchedResultsController<Posts>?

    func retrieveDataFromCoreData() {
        
        if let context = self.container?.viewContext {
            let request: NSFetchRequest<Posts> = Posts.fetchRequest()
        
            request.sortDescriptors = [NSSortDescriptor(key:  (\Posts.id)._kvcKeyPathString!, ascending: false)]
        
            self.fetchedResultsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            
            fetchedResultsController?.delegate = self
        
            do {
                try self.fetchedResultsController?.performFetch()
            } catch {
                print("Failed to initialize FetchedResultsController: \(error)")
            }
        }
    }

    func numberOfRowsInSection (section: Int) -> Int {
        return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    func object (indexPath: IndexPath) -> Posts? {
        return fetchedResultsController?.object(at: indexPath)
    }
    func object (id: Int64) -> Posts? {
        var object: Posts?
        let context = fetchedResultsController?.managedObjectContext
        let fetchRequest: NSFetchRequest<Posts> = Posts.fetchRequest()
        do{
            let posts = try context?.fetch(fetchRequest)
            for post in posts! as [Posts] {
                if(post.id == id){
                    object = post
                }
            }
        } catch let error {
            print(error.localizedDescription)
            object = nil
        }
        return object
    }
}
