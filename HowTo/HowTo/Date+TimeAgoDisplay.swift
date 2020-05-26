//
//  Date+TimeAgoDisplay.swift
//  HowTo
//
//  Created by Shawn James on 5/26/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import UIKit

extension Date {
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        // properties
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        // seconds ago
        if secondsAgo < minute { return "\(secondsAgo)s" }
        // minutes ago
        else if secondsAgo < hour { return "\(secondsAgo / minute)m" }
        // hours ago
        else if secondsAgo < day { return "\(secondsAgo / hour)h" }
        // days ago
        else if secondsAgo < week { return "\(secondsAgo / day)d" }
        // weeks ago
        return "\(secondsAgo / week)w"
    }
}

/*
Example of how to use
let now = Date()
let pastDate = Date(timeIntervalSinceNow: -604800)
pastDate.timeAgoDisplay()
*/
