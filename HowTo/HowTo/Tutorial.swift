//
//  Tutorial.swift
//  HowTo
//
//  Created by Shawn James on 5/27/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

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
}

struct Comment: Codable {
    let text: String
    let author: String
}
