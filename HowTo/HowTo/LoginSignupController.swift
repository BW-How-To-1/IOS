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
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
        case patch = "PATCH"
        case head = "HEAD"
        case options = "OPTIONS"
        case connect = "CONNECT"
    }
    
    
    //MARK: - Properties -
    var bearer: Bearer?
    
    private var baseURL = URL(string: "www.google.com/") //TODO: Add baseURL from back-end or firebase DB here.
    private var loginURL = baseURL.appendPathComponent("login") //TODO: Add correct path component
    private var signupURL = baseURL.appendPathComponent("signup") //TODO: Add correct path component.
    
    private lazy var jsonEncoder = JSONEncoder()
    private lazy var jsonDecoder = JSONDecoder()
    
    
    //MARK: - Actions -
    /// login and signup actions go here
    
    
    
    
    //MARK: - Methods -
    ///URLHandlers, decoding helpers, etc. go here.
    
}
