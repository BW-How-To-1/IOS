//
//  NetworkController.swift
//  HowTo
//
//  Created by Cody Morley on 5/26/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import Foundation
import CoreData

class NetworkController {
    //MARK: - Enums & Type Aliases -
    enum NetworkError: Error {
        case noEncode
    }
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
        case patch = "PATCH"
    }
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    typealias TutorialHandler = (Result<[Tutorial], NetworkError>) -> Void
    
    //MARK: - Properties -
    lazy var bearer: Bearer? = LoginSignupController.shared.bearer
    
    let baseURL = URL(string: "https://how-to-diy.herokuapp.com/api/")!
    lazy var postURL = baseURL.appendingPathComponent("/posturl/") //TODO: NEEDS CORRECT ENDPOINT
    
    var jsonEncoder = JSONEncoder()
    var jsonDecoder = JSONDecoder()
    
    
    
    
    
    //MARK: - Actions -
    ///post how-to to server
    func postTutorial(for tutorial: Tutorial, completion: @escaping CompletionHandler) {
        var request = postRequest(for: postURL)
        
        do {
            let jsonRequest = try jsonEncoder.encode(tutorial)
            request.httpBody = jsonRequest
        } catch {
            NSLog("Error encoding tutorial: \(error) \(error.localizedDescription)")
            completion(.failure(.noEncode))
        }
        
        
        
    }
    
    ///get and sort all relevant how-to articles from back-end
    func getTutorial() {
        
    }
    
    ///update local how-tos with server
    func updateTutorials() {
        
    }
    
    ///delete how-to from server
    func deleteTutorials() {
        
    }
    
    
    
    
    
    //MARK: - Methods -
    ///update helper
    func update() {
        
    }
    
    ///create methods helpers
    private func getRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    private func postRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }

    private func deleteRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.delete.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    
}
