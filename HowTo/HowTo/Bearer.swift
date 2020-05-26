//
//  Bearer.swift
//  HowTo
//
//  Created by Cody Morley on 5/26/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import Foundation

struct Bearer: Codable {
    //TODO: - Add login variables according to back-end model. Leaving token here for now since that's the most likely to remain the norm.
    
    var token: String
}
