//
//  TutorialRepresentation.swift
//  HowTo
//
//  Created by Bling Morley on 5/27/20.
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
        case dateCreated
    }
    
    let id: String
    var title: String
    var bodyText: String
    let image: URL
    var likes: Int64
    let author: String
    let dateCreated: Date
}
