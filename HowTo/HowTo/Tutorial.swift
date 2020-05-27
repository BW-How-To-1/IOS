//
//  Tutorial.swift
//  HowTo
//
//  Created by Shawn James on 5/27/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

/*
import Foundation

/// These are the objects that hold the HowTo objects that users create and are displayed in the HomeTableViewController
struct Tutorial: Codable {
    let id: String
    var title: String
    var bodyText: String
    let image: URL
    var likes: Int64
    let author: String
    let dateCreated: Date
    var comments: [Comment]
    
    init(id: String, title: String, bodyText: String, image: URL, likes: Int64, author: String, dateCreated: Date, comments: [Comment]) {
        self.id = id
        self.title = title
        self.bodyText = bodyText
        self.image = image
        self.likes = likes
        self.author = author
        self.dateCreated = dateCreated
        self.comments = comments
    }
}

struct Comment: Codable {
    let text: String
    let author: String
}

////////////////////////////////////////////////////
// FIXME: - temporary mockData
let mockComment1 = Comment(text: "This is the first comment!", author: "FirstUser2342")
let mockComment2 = Comment(text: "What about another one?!", author: "ScoobyDoo342")
let mockDataObject1 = Tutorial(id: UUID().uuidString,
                               title: "How To Train Your Dragon",
                               bodyText:
"""
Here are some nice resources that might help you:
http://www.google.com/
that's all! Good luck!

Steps:
1. Find a dragon
2. Sit on top of it
3. Fly away
""",
                               image: URL(string: "http://www.google.com/")!,
                               likes: 4,
                               author: "Squidward",
                               dateCreated: Date(timeIntervalSinceNow: -60800),
                               comments: [mockComment1, mockComment2])
let mockDataObject2 = Tutorial(id: UUID().uuidString,
                               title: "How To Cook Squirrel Tail",
                               bodyText:
"""
You should be sure to have these ingredients before starting:
- squirrel
- water
- salt

Steps:
1. Salt the squirrell
2. Let it go free
3. Don't actually eat it, that would be gross
""",
                               image: URL(string: "http://www.google1.com/")!,
                               likes: 1,
                               author: "AwesomeUsername4021",
                               dateCreated: Date(timeIntervalSinceNow: -170),
                               comments: [mockComment1, mockComment2])
*/
