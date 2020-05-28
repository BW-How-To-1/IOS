//
//  UIImage+JPEGData.swift
//  HowTo
//
//  Created by Shawn James on 5/28/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import UIKit

extension UIImage {
    var jpeg: Data? { jpegData(compressionQuality: 1) }
}
