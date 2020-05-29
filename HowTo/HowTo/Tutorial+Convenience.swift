//
//  Tutorial+Convenience.swift
//  HowTo
//
//  Created by Cody Morley on 5/27/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import Foundation
import CoreData

extension Tutorial {
    //MARK: - Properties -
    var representation: TutorialRepresentation? {
        guard let title = title,
            let bodyText = bodyText,
            let author = author,
            let dateCreated = dateCreated else {
                return nil
        }
        return TutorialRepresentation(id: Int(id),
                                      title: title,
                                      bodyText: bodyText,
                                      image: image,
                                      likes: String(likes),
                                      author: author,
                                      dateCreated: dateCreated)
    }
    
    
    //MARK: - Convenience Initializers -
    @discardableResult convenience init(id: Int64 = Int64.random(in: 256...4096),
                                        dateCreated: Date = Date(),
                                        author: String,
                                        title: String,
                                        bodyText: String,
                                        image: String?,
                                        likes: Int64 = 0,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.id = id
        self.dateCreated = dateCreated
        self.author = author
        self.title = title
        self.bodyText = bodyText
        self.image = image
        self.likes = likes
    }
    
    @discardableResult convenience init?(representation: TutorialRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        var likesString: String
        if let likes = representation.likes {
            likesString = likes
        } else {
            likesString = "0"
        }
        
        guard let likes64 = Int64(likesString) else {
            return nil
        }
        
        self.init(id: Int64(representation.id),
                      dateCreated: representation.dateCreated ?? Date(),
                      author: representation.author ?? "anonymous",
                      title: representation.title ?? "untitled",
                      bodyText: representation.bodyText ?? " ",
                      image: representation.image,
                      likes: likes64,
                      context: context)
    }
    
    
}
