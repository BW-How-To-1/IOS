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
        guard let identifier = id,
            let title = title,
            let bodyText = bodyText,
            let author = author,
            let dateCreated = dateCreated else {
                return nil
        }
        
        return TutorialRepresentation(id: identifier.uuidString,
                                      title: title,
                                      bodyText: bodyText,
                                      image: image,
                                      likes: likes,
                                      author: author,
                                      dateCreated: dateCreated)
    }
    
    
    
    //MARK: - Convenience Initializers -
    @discardableResult convenience init(id: UUID = UUID(),
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
        guard let identifier = UUID(uuidString: representation.id) else {
            return nil
        }
        
        self.init(id: identifier,
                  dateCreated: representation.dateCreated,
                  author: representation.author,
                  title: representation.author,
                  bodyText: representation.bodyText,
                  image: representation.image,
                  likes: representation.likes,
                  context: context)
    }
    
    
    //MARK: - Photo methods -
    /// method for coercing photos from URL Strings.
}
