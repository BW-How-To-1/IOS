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
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    typealias TutorialHandler = (Result<[Tutorial], NetworkError>) -> Void
    typealias CommentHandler = (Result<[Comment], NetworkError>) -> Void
    
    //MARK: - Properties -
    static let shared = NetworkController()
    lazy var bearer: Bearer? = LoginSignupController.shared.bearer
    
    ///firebase endpoints
//    let baseURL = URL(string: "https://howto-56e14.firebaseio.com/")!
//    let postURL = URL(string: "https://howto-56e14.firebaseio.com/")!
//    let getURL = URL(string: "https://howto-56e14.firebaseio.com/")!
//    let tutorialURL = URL(string: "https://howto-56e14.firebaseio.com/")!
//    let commentURL = URL(string: "https://howto-56e14.firebaseio.com/")!
    
    ///project back-end endpoints
    let baseURL = URL(string: "https://how-to-diy.herokuapp.com/")!
    lazy var tutorialsURL = baseURL.appendingPathComponent("/projects/")
    lazy var commentsURL = baseURL.appendingPathComponent("/comments/")
    
    var jsonEncoder = JSONEncoder()
    var jsonDecoder = JSONDecoder()
    
    var networkDataLoader: NetworkDataLoader
    
    
    // MARK: - Lifecycle
    init(networkDataLoader: NetworkDataLoader = URLSession.shared) {
        self.networkDataLoader = networkDataLoader
        getTutorials(completion: { _ in })
    }
    
    
    //MARK: - Actions -
    ///post how-to to server
    func postTutorial(for tutorial: Tutorial, completion: @escaping CompletionHandler) {
        guard let bearer = bearer else {
            NSLog("Error: No authentication token. Please log in.")
            completion(.failure(.noToken))
            return
        }
        
        var request = postRequest(for: tutorialsURL, with: bearer)
        
        do {
            let jsonRequest = try jsonEncoder.encode(tutorial.representation)
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
                response.statusCode == 201 else { //TODO: <- MAKE SURE THIS IS RIGHT
                    NSLog("Error: Bad or no response from server when posting tutorial.")
                    completion(.failure(.badResponse))
                    return
            }
            completion(.success(true))
        }.resume()
    }
    
    ///edit a tutorial on the server
    func editTutorial (for tutorial: Tutorial, completion: @escaping CompletionHandler) {
        guard let bearer = bearer else {
            NSLog("Error: No authentication token. Please log in.")
            completion(.failure(.noToken))
            return
        }
        
        let requestURL = singleTutorialURL(tutorial)
        var request = postRequest(for: requestURL, with: bearer)
        
        do {
            let jsonRequest = try jsonEncoder.encode(tutorial.representation)
            request.httpBody = jsonRequest
        } catch {
            NSLog("Error encoding edited tutorial: \(error) \(error.localizedDescription)")
            completion(.failure(.noEncode))
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                NSLog("Error posting edited tutorial to server: \(error) \(error.localizedDescription)")
                completion(.failure(.otherError))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200 else { //TODO: <- MAKE SURE THIS IS RIGHT
                    NSLog("Error: Bad or no response from server when posting edited tutorial.")
                    completion(.failure(.badResponse))
                    return
            }
            completion(.success(true))
        }.resume()
    }
    
    ///get and sort all relevant how-to articles from back-end
    //TODO: REFACTOR FOR CORE DATA SUPPORT - update, sort, and save in the final do-block
    func getTutorials(completion: @escaping TutorialHandler) {
        let request = getRequest(for: tutorialsURL)
        
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
                let allTutorialReps = try self.jsonDecoder.decode([TutorialRepresentation].self, from: data)
                var allTutorials: [Tutorial] = []
                for rep in allTutorialReps {
                    if let newTutorial = Tutorial(representation: rep) {
                        allTutorials.append(newTutorial)
                    }
                }
                try self.updateTutorials(with: allTutorialReps) // syncing
                completion(.success(allTutorials))
            } catch {
                NSLog("Error decoding data from get request: \(error) \(error.localizedDescription)")
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }
    
    ///update local how-tos with server
    private func updateTutorials(with representations: [TutorialRepresentation]) throws {        
        let identifiersToFetch = representations.compactMap { $0.id }
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        var tutorialsToCreate = representationsByID
        
        // create fetch request
        let fetchRequest: NSFetchRequest<Tutorial> = Tutorial.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id IN %@", identifiersToFetch)
        let mainContext = CoreDataStack.shared.mainContext
        
        do {
            let existingTutorials = try mainContext.fetch(fetchRequest)
            
            for tutorial in existingTutorials {
                let idAsInt = Int(tutorial.id)
                //                let id = Int(idAsString)
                guard let representation = representationsByID[idAsInt] else { continue }
                self.update(tutorial: tutorial, with: representation)
                tutorialsToCreate.removeValue(forKey: idAsInt)
            }
            for representation in tutorialsToCreate.values {
                Tutorial(representation: representation)
            }
        } catch {
            NSLog("Error fetching tutorials with id's: \(identifiersToFetch), with error: \(error)")
        }
        // save to core data
        try CoreDataStack.shared.mainContext.save()
    }
    
    ///delete how-to from server
    func deleteTutorial(_ tutorial: Tutorial, completion: @escaping CompletionHandler) {
        guard let bearer = bearer else {
            NSLog("Error when deleting tutorial: No authorization token, please log in.")
            completion(.failure(.noToken))
            return
        }
        let requestURL = singleTutorialURL(tutorial)
        let request = deleteRequest(for: requestURL, with: bearer)
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                NSLog("Error deleting tutorial from server: \(error) \(error.localizedDescription)")
                completion(.failure(.otherError))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200 else { //TODO: Make sure this is right
                    NSLog("Error: Bad or no response when deleting tutorial from server.")
                    completion(.failure(.badResponse))
                    return
            }
            completion(.success(true))
        }.resume()
    }
    
    func getComments(completion: @escaping CommentHandler) {
        let request = getRequest(for: commentsURL)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("Error when retrieving comments from server: \(error) \(error.localizedDescription)")
                completion(.failure(.otherError))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200 else {
                    NSLog("Error: Bad or no response from server when retrieving comments from server.")
                    completion(.failure(.badResponse))
                    return
            }
            
            guard let data = data else {
                NSLog("Error: No data recieved when retrieving comments from server.")
                completion(.failure(.noData))
                return
            }
            
            do {
                let allCommentReps = try self.jsonDecoder.decode([CommentRepresentation].self, from: data)
                var allComments:[Comment] = []
                for rep in allCommentReps {
                    if let newComment = Comment(representation: rep) {
                        allComments.append(newComment)
                    }
                }
                try self.updateComments(with: allCommentReps)
                completion(.success(allComments))
            } catch {
                NSLog("Error decoding comment data: \(error) \(error.localizedDescription)")
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }
    
    func updateComments(with representations: [CommentRepresentation]) throws {
        let identifiersToFetch = representations.compactMap { $0.id }
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        var commentsToCreate = representationsByID
        
        let fetchRequest: NSFetchRequest<Comment> = Comment.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id IN %@", identifiersToFetch)
        let context = CoreDataStack.shared.mainContext
        
        do {
            let existingComments = try context.fetch(fetchRequest)
            for comment in existingComments {
                let idInt = Int(comment.id)
                guard let representation = representationsByID[idInt] else { continue }
                self.editComment(comment: comment, with: representation)
                commentsToCreate.removeValue(forKey: idInt)
            }
            for representation in commentsToCreate.values {
                Comment(representation: representation)
            }
        } catch {
            NSLog("Error: Failed updating comments")
        }
        try CoreDataStack.shared.mainContext.save()
    }
    
    func postComment(for comment: Comment, completion: @escaping CompletionHandler) {
        guard let bearer = bearer else {
            NSLog("Error: No authentication token. Please log in.")
            completion(.failure(.noToken))
            return
        }
        
        let requestURL = postCommentURL(comment)
        var request = postRequest(for: requestURL, with: bearer)
        
        do {
            let jsonRequest = try jsonEncoder.encode(comment.representation)
            request.httpBody = jsonRequest
        } catch {
            NSLog("Error encoding comment: \(error) \(error.localizedDescription)")
            completion(.failure(.noEncode))
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                NSLog("Error posting comment to server: \(error) \(error.localizedDescription)")
                completion(.failure(.otherError))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                response.statusCode == 201 else { //TODO: <- MAKE SURE THIS IS RIGHT
                    NSLog("Error: Bad or no response from server when posting comment.")
                    completion(.failure(.badResponse))
                    return
            }
            completion(.success(true))
        }.resume()
        
    }
    
    func deleteComment(_ comment: Comment, completion: @escaping CompletionHandler) {
        guard let bearer = bearer else {
            NSLog("Error when deleting comment: No authorization token, please log in.")
            completion(.failure(.noToken))
            return
        }
        
        let requestURL = singleCommentURL(comment)
        let request = deleteRequest(for: requestURL, with: bearer)
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                NSLog("Error deleting comment from server: \(error) \(error.localizedDescription)")
                completion(.failure(.otherError))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200 else { //TODO: Make sure this is right
                    NSLog("Error: Bad or no response when deleting comment from server.")
                    completion(.failure(.badResponse))
                    return
            }
            completion(.success(true))
        }.resume()
    }
    
    
    
    //MARK: - Methods -
    ///update helpers
    private func update(tutorial: Tutorial, with representation: TutorialRepresentation) {
        tutorial.author = representation.author
        tutorial.bodyText = representation.bodyText
        tutorial.dateCreated = representation.dateCreated
        tutorial.id = Int64(representation.id)
        tutorial.image = representation.image
        tutorial.likes = representation.likes
        tutorial.title = representation.title
    }
    
    private func editComment(comment: Comment, with representation: CommentRepresentation) {
        comment.title = representation.title
        comment.text = representation.text
    }
    
    ///create methods helpers
    private func getRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    private func postRequest(for url: URL, with bearer: Bearer) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(bearer.token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func putRequest(for url: URL, with bearer: Bearer) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.put.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(bearer.token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func deleteRequest(for url: URL, with bearer: Bearer) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.delete.rawValue
        request.setValue("\(bearer.token)", forHTTPHeaderField: "Authorization")
        return request
    }
   
    ///URL Helpers
    private func singleTutorialURL(_ tutorial: Tutorial) -> URL {
        let tutorialIDString = String(describing: tutorial.id)
        let individualTutorialURL = baseURL.appendingPathComponent("/projects/\(tutorialIDString)/")
        return individualTutorialURL
    }
    
    private func singleCommentURL(_ comment: Comment) -> URL {
        let commentIDString = String(describing: comment.id)
        let individualCommentURL = baseURL.appendingPathComponent("/comments/\(commentIDString)/")
        return individualCommentURL
        
    }
    
    private func postCommentURL(_ comment: Comment) -> URL {
        let newCommentTutorialString = String(describing: comment.tutorial?.id)
        let postCommentURL = baseURL.appendingPathComponent("/projects/comments/\(newCommentTutorialString)")
        return postCommentURL
    }
    
}
