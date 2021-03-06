//
//  CommentRepresentation.swift
//  HowTo
//
//  Created by Cody Morley on 5/27/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import Foundation

struct CommentRepresentation: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case dateCreated = "date"
        case author
        case title
        case text = "comments"
    }
    
    let id: Int
    let dateCreated: Date
    let author: String
    var title: String?
    var text: String
}
