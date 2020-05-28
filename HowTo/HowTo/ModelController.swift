//
//  ModelController.swift
//  HowTo
//
//  Created by Cody Morley on 5/28/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import Foundation
import CoreData

class ModelController {
    //MARK: - Properties -
    static let shared = ModelController()
    
    
    //MARK: - Actions -
    ///This Controller only holds the methods for creation and deletion in Core Data. For read/synch methods, use the update functions of NetworkController.swift
    /// you may either initialize a new object before using these functions or do so in the arguments with the proper initializer. Combined with the convenience inits this means you can use them with a codable representation by calling the correct object convenience init.
    func createTutorial(_ tutorial: Tutorial) {
        guard let _ = tutorial.id else { return }
        
        let context = CoreDataStack.shared.mainContext
        
        DispatchQueue.main.async {
            context.perform {
                NetworkController.shared.postTutorial(for: tutorial) { _ in }
            }
        }
        
        do {
            try CoreDataStack.shared.save(context: CoreDataStack.shared.persistentContainer.newBackgroundContext())
        } catch {
            NSLog("Error saving new tutorial to persistent container: \(error) \(error.localizedDescription)")
            return
        }
    }
    
    func createComment(_ comment: Comment, for tutorial: Tutorial) {
        guard let _ = comment.id,
            let _ = tutorial.id else {
                return
        }
        let newComment = comment
        let context = CoreDataStack.shared.mainContext
        tutorial.addToComments(newComment)
        
        DispatchQueue.main.async {
            context.perform {
                NetworkController.shared.postComment(for: newComment) { _ in }
            }
        }
        
        do {
            try CoreDataStack.shared.save(context: CoreDataStack.shared.persistentContainer.newBackgroundContext())
        } catch {
            NSLog("Error saving new comment to persistent container: \(error) \(error.localizedDescription)")
            return
        }
    }
    
    
    func deleteTutorial(_ tutorial: Tutorial) {
        let context = CoreDataStack.shared.persistentContainer.newBackgroundContext()
        context.delete(tutorial)
        context.performAndWait {
            do {
                try context.save()
            } catch {
                NSLog("Error deleting tutorial from persistent stores, aborting deletion: \(error) \(error.localizedDescription)")
                return
            }
        }
        
        DispatchQueue.main.async {
            NetworkController.shared.deleteTutorial(tutorial, completion: { _ in })
        }
    }
    
    func deleteComment(_ comment: Comment) {
        let context = CoreDataStack.shared.persistentContainer.newBackgroundContext()
        context.delete(comment)
        context.performAndWait {
            do {
                try context.save()
            } catch {
                NSLog("Error deleting comment from persistent stores, aborting deletion: \(error) \(error.localizedDescription)")
                return
            }
        }
        
        DispatchQueue.main.async {
            NetworkController.shared.deleteComment(comment) { _ in }
        }
    }
}
