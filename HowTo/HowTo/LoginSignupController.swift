//
//  LoginSignupController.swift
//  HowTo
//
//  Created by Cody Morley on 5/26/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import Foundation
import CoreData

class LoginSignupController {
    //MARK: - Enums & Type Aliases -
    enum HTTPMethod: String {
        case post = "POST"
    }
    
    enum NetworkError: Error {
        case badResponse
        case noData
        case noDecode
        case noEncode
        case otherError
    }
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    
    //MARK: - Properties -
    var bearer: Bearer?
    static let shared = LoginSignupController()
    
    private var baseURL = URL(string: "https://how-to-diy.herokuapp.com/api/")!
    private lazy var loginURL = baseURL.appendingPathComponent("auth/login/")
    private lazy var signupURL = baseURL.appendingPathComponent("auth/register/")
    
    private lazy var jsonEncoder = JSONEncoder()
    private lazy var jsonDecoder = JSONDecoder()
    
    var networkDataLoader: NetworkDataLoader

    // MARK: - Lifecycle
    init(networkDataLoader: NetworkDataLoader = URLSession.shared) {
        self.networkDataLoader = networkDataLoader
    }
    
    //MARK: - Actions -
    func signUp(as user: User, completion: @escaping CompletionHandler) {
        var request = URLRequest(url: signupURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let encodedUser = try jsonEncoder.encode(user)
            request.httpBody = encodedUser
        } catch {
            NSLog("Error encoding user info: \(error) \(error.localizedDescription)")
            completion(.failure(.noEncode))
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                NSLog("Error signing in: \(error) \(error.localizedDescription)")
                completion(.failure(.otherError))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                response.statusCode == 201 else {
                    NSLog("Error: Bad or no response from remote host. Sign up failed.")
                    completion(.failure(.badResponse))
                    return
            }
            
            completion(.success(true))
        }.resume()
    }
    
    func logIn(as user: User, completion: @escaping CompletionHandler) {
        var request = URLRequest(url: loginURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let encodedUser = try jsonEncoder.encode(user)
            request.httpBody = encodedUser
        } catch {
            NSLog("Error encoding user info: \(error) \(error.localizedDescription)")
            completion(.failure(.noEncode))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("Error logging in: \(error) \(error.localizedDescription)")
                completion(.failure(.otherError))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200 else {
                    NSLog("Error: Bad or no response from server when logging in.")
                    completion(.failure(.badResponse))
                    return
            }
            
            guard let tokenData = data else {
                NSLog("No token recieved from server.")
                completion(.failure(.noData))
                return
            }
            
            do {
                self.bearer = try self.jsonDecoder.decode(Bearer.self, from: tokenData)
            } catch {
                NSLog("Error decoding token from server.")
                completion(.failure(.noDecode))
                return
            }
            
            completion(.success(true))
            
        }.resume()
    }
    
    
}
