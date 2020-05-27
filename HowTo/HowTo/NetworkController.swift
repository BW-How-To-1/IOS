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
        case badResponse
        case noData
        case noDecode
        case noEncode
        case otherError
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
    lazy var getURL = baseURL.appendingPathComponent("/geturl") //TODO: NEEDS CORRECT ENDPOINT
    
    var jsonEncoder = JSONEncoder()
    var jsonDecoder = JSONDecoder()
    
    
    
    
    
    //MARK: - Actions -
    ///post how-to to server
    func postTutorial(for tutorial: Tutorial, completion: @escaping CompletionHandler) {
        var request = postRequest(for: postURL)
        
        do {
            let jsonRequest = try jsonEncoder.encode(tutorial) //TODO: This will be a codable .rep
            request.httpBody = jsonRequest
        } catch {
            NSLog("Error encoding tutorial: \(error) \(error.localizedDescription)")
            completion(.failure(.noEncode))
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                NSLog("Error posting tutorial to server: \(error) \(error.localizedDescription)")
                completion(.failure(.otherError))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200 else { //TODO: <- MAKE SURE THIS IS RIGHT
                    NSLog("Error: Bad or no response from server when posting tutorial.")
                    completion(.failure(.badResponse))
                    return
            }
            completion(.success(true))
        }.resume()
    }
    
    ///get and sort all relevant how-to articles from back-end
    //TODO: REFACTOR FOR CORE DATA SUPPORT - update, sort, and save in the final do-block
    func getTutorials(completion: @ escaping TutorialHandler) {
        let request = getRequest(for: getURL)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("Error when retrieving tutorials from server: \(error) \(error.localizedDescription)")
                completion(.failure(.otherError))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200 else {
                    NSLog("Error: Bad or no response when processing get request.")
                    completion(.failure(.badResponse))
                    return
            }
            
            guard let data = data else {
                NSLog("No data returned from get request.")
                completion(.failure(.noData))
                return
            }
            
            do {
                let allTutorials = try self.jsonDecoder.decode([Tutorial].self, from: data)
                completion(.success(allTutorials))
            } catch {
                NSLog("Error decoding data from get request: \(error) \(error.localizedDescription)")
                completion(.failure(.noDecode))
                return
            }
        }.resume()
        
        
        
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
