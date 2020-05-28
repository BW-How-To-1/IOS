//
//  CloudinaryController.swift
//  HowTo
//
//  Created by Shawn James on 5/28/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case badResponse
    case noData
    case noDecode
    case noEncode
    case noToken
    case otherError
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

class CloudinaryController {

    let imageUploadURL = URL(string: "https://api.cloudinary.com/v1_1/dehqhte0i/image/upload")!
    let spriteGenerationURL = URL(string: "https://api.cloudinary.com/v1_1/dehqhte0i/image/sprite")!
    let apiKey = "959718959598545"
    
    var jsonEncoder = JSONEncoder()
    var jsonDecoder = JSONDecoder()
    
    var networkDataLoader: NetworkDataLoader

    // MARK: - Lifecycle
    init(networkDataLoader: NetworkDataLoader = URLSession.shared) {
        self.networkDataLoader = networkDataLoader
    }
    
    //MARK: - Actions -
    
}
