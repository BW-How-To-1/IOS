//
//  Comment+Convenience.swift
//  HowTo
//
//  Created by Cody Morley on 5/27/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import Foundation
import CoreData

extension Comment {
    //MARK: - Properties -
    var representation: CommentRepresentation? {
        guard let id = id,
        let author = author,
            let date = dateCreated,
            let text = text else {
                return nil
        }
        return CommentRepresentation(id: id.uuidString,
                                     dateCreated: date,
                                     author: author,
                                     title: title,
                                     text: text)
    }
    
    
    
    //MARK: - Convenience Initializers -
    @discardableResult convenience init(id: UUID = UUID(),
                                        dateCreated: Date = Date(),
                                        author: String,
                                        text: String,
                                        title: String?,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.id = id
        self.dateCreated = dateCreated
        self.author = author
        self.text = text
        self.title = title
    }
    
    @discardableResult convenience init?(representation: CommentRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let identifier = UUID(uuidString: representation.id) else {
            return nil
        }
        
        self.init(id: identifier,
                  author: representation.author,
                  text: representation.text,
                  title: representation.title,
                  context: context)
    }
    
    
    
}
