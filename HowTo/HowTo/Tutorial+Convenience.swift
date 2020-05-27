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
    
    
    
    
    
    //MARK: - Photo methods -
    /// method for coercing photos from URL Strings.
}
