//
//  User.swift
//  HowTo
//
//  Created by Cody Morley on 5/26/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import Foundation

struct User: Codable {
    let username: String
    let password: String
    
    init(username: String,
         password: String) {
        
        self.username = username
        self.password = password
    }
}
