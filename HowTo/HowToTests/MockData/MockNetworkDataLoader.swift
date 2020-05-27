//
//  MockNetworkDataLoader.swift
//  HowToTests
//
//  Created by Shawn James on 5/27/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import Foundation
@testable import HowTo

class MockNetworkDataLoader: NetworkDataLoader {
    // create variables
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    // conform to protocol
    func loadData(using request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(self.data, self.response, self.error)
        }
    }

    
}
