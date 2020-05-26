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
        
    }
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
        case patch = "PATCH"
        case head = "HEAD"
        case options = "OPTIONS"
        case connect = "CONNECT"
    }
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    //typealias HowToHandler = (Result<[HowTo], NetworkError>) -> Void
    
    //MARK: - Properties -
    lazy var bearer: Bearer? = LoginSignupController.shared.bearer
    
    let baseURL = URL(string: "www.google.com")! //TODO: Add real URL from back-end
    
    
    
    
    //MARK: - Actions -
    ///post how-to to server
    func postHowTo() {
        
    }
    
    ///get and sort all relevant how-to articles from back-end
    func getHowTo() {
        
    }
    
    ///update local how-tos with server
    func updateHowTos() {
        
    }
    
    ///delete how-to from server
    func deleteHowTo() {
        
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
