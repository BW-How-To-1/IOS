//
//  HowToTests.swift
//  HowToTests
//
//  Created by Shawn James on 5/22/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import XCTest
@testable import HowTo

class HowToTests: XCTestCase {
    
    /*
     
     Does decoding work?
     Does decoding fail when given bad data?
     Does it build the correct URL?
     Does it build the correct URLRequest?
     Are the search results saved properly?
     Is the completion handler called when data is good?
     Is the completion handler called when data is bad?
     Is the completion handler called when networking fails?
     
     */
        
        // MARK: - Live data
        
        func testLiveLogin() {
            let loginSignupController = LoginSignupController()
            let loginExpectation = XCTestExpectation(description: "Wait for login result")
            let testUser = User(username: "Testing", password: "Testing")
            
            loginSignupController.logIn(as: testUser) { (result) in
                print("The login responded with something.")
                XCTAssertNotNil(loginSignupController.bearer?.token)
                loginExpectation.fulfill()
            }
            wait(for: [loginExpectation], timeout: 5)
            XCTAssertNotNil(loginSignupController.bearer?.token)
        }
    }

}
