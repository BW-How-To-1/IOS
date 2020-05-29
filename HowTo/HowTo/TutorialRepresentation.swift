//
//  TutorialRepresentation.swift
//  HowTo
//
//  Created by Cody Morley on 5/27/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import Foundation

struct TutorialRepresentation: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case bodyText
        case image
        case likes
        case author
        case dateCreated = "date"
    }
    
    let id: Int
    var title: String
    var bodyText: String
    var image: String?
    var likes: Int64
    let author: String
    let dateCreated: Date
}
