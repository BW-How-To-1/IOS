//
//  String+Keys.swift
//  HowTo
//
//  Created by Shawn James on 5/23/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import Foundation

extension String {
    // user defaults keys
    /// bool that determines whether this is the first time the app has been launched
    static let firstLaunchKey = "firstLanch"
    /// bool that determines whether the user is loggedIn or using the app as a guest
    static let isLoggedInKey = "isLoggedIn"
    /// holds the username as a string
    static let usernameKey = "username"
    static let passwordKey = "password"
    // tableViewCell id keys
    static let homeTableViewCellId = "HomeTableViewCell"
    static let menuListControllerCellId = "cell"
    static let commentTableViewCellId = "CommentCell"
    // segueId keys
    static let showOnboardingSegueId = "ShowOnboarding"
    static let showNewPostSegueId = "ShowNewPost"
    static let goToSignUpSegueId = "GoToSignUp"
    static let goToLoginSegueId = "GoToLogin"
}
