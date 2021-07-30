//
//  DetailsListViewModel.swift
//  AmadeusTask
//
//  Created by Arturas Krivenkis on 2021-07-14.
//

import Foundation
import UIKit
import CoreData

protocol UpdateTableViewDelegate: NSObjectProtocol {
    func reloadData(sender: DetailsListViewModel)
}

class DetailsListViewModel: NSObject, NSFetchedResultsControllerDelegate {
    
    private let container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    private var fetchedResultsController: NSFetchedResultsController<Details>?
    
    weak var delegate: UpdateTableViewDelegate?
    
    func retrieveDataFromCoreData() {
        
        if let context = self.container?.viewContext {
            let request: NSFetchRequest<Details> = Details.fetchRequest()
            
            request.sortDescriptors = [NSSortDescriptor(key:  (\Details.id)._kvcKeyPathString!, ascending: false)]
            
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
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.delegate?.reloadData(sender: self)
    }
    func object (id: Int64) -> Details? {
        var object: Details?
        let context = fetchedResultsController?.managedObjectContext
        let fetchRequest: NSFetchRequest<Details> = Details.fetchRequest()
        do{
            let details = try context?.fetch(fetchRequest)
            for detail in details! as [Details] {
                if(detail.id == id){
                    object = detail
                }
            }
        } catch let error {
            print(error.localizedDescription)
            object = nil
        }
        return object
    }
}
