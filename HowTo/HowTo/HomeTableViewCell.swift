//
//  HomeTableViewCell.swift
//  HowTo
//
//  Created by Shawn James on 5/23/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import UIKit

protocol AlertControllerDelegate {
    func presentAlert(with text: String)
}

class HomeTableViewCell: UITableViewCell {
    
    // MARK: - Outlets & properties
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var likesCount: UILabel!
    @IBOutlet weak var commentsCount: UILabel!
    @IBOutlet weak var ageOfPost: UILabel!
    @IBOutlet weak var authorlabel: UILabel!
    
    var userHasLikedThisPost: Bool = false
    // TODO: dependancy inject for HowTo object
    var alertControllerDelegate: AlertControllerDelegate?
    
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        updateViews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Actions & methods
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        // this checks to see if the user is logged in and doesn't like the same post more than once.
        if UserDefaults.standard.bool(forKey: .isLoggedInKey) {
            guard !userHasLikedThisPost else {
                alertControllerDelegate?.presentAlert(with: "You have already liked this post!")
                return
            }
            userHasLikedThisPost = true
            // TODO: increment likeCount by one here
        } else {
            // present alert because user is a guest and can't like posts
            alertControllerDelegate?.presentAlert(with: "You Must Be Logged in to Like This Post.")
        }
    }
    
    private func updateViews() {
        // adds cell border
        layer.borderWidth = 0.3
        layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 0.85)
        // TODO: unwrap injected object and assign it all it's properties
        //        guard let <#HowTo object name#> = <#HowTo object name#> else { return }
        //        ageOfPost.text = <#HowTo object name#>.datePosted.timeAgoDisplay()
    }
    
}
