//
//  DetailViewController.swift
//  HowTo
//
//  Created by Shawn James on 5/24/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - Outlets & properties
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageBlur: UIVisualEffectView!
    // popover
    @IBOutlet var editPostPopOver: UIView!
    @IBOutlet weak var editPostButton: UIButton!
    @IBOutlet weak var editContentButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    // MARK: - Acitons & Methods
    @IBAction func editPostButtonTapped(_ sender: UIButton) {
        // TODO: guard to make sure user = author, otherwise they can't use or see this button. needs ", author = author below
        guard UserDefaults.standard.bool(forKey: .isLoggedInKey) else { return }
        self.view.addSubview(editPostPopOver)
        // fade in
        editPostPopOver.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.editPostPopOver.alpha = 1
            self.imageBlur.alpha = 1
        }
        // set location
        editPostPopOver.center = editPostButton.center
        editPostPopOver.center.y = editPostButton.center.y + 71
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        self.editPostPopOver.removeFromSuperview()
        self.imageBlur.alpha = 0
    }
    
    @IBAction func editContentButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func sendCommentButtonTapped(_ sender: UIButton) {
        if UserDefaults.standard.bool(forKey: .isLoggedInKey) {
            // TODO: "send" a comment to the post with matching post.id
        } else {
            // present alert because user is a guest and can't post
            let alert = UIAlertController(title: "You Must Be Logged in to Post Comments", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    
    private func updateViews() {
        self.editPostPopOver.layer.cornerRadius = 10
        self.editContentButton.layer.cornerRadius = 5
        self.deleteButton.layer.cornerRadius = 5
        editPostButton.alpha = 0
        if UserDefaults.standard.bool(forKey: .isLoggedInKey) {
            // TODO: if user == author, then show edit post button, otherwise hide it. add && author = author above
            editPostButton.alpha = 1
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
