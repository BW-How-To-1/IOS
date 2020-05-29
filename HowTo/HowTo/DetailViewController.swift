//
//  DetailViewController.swift
//  HowTo
//
//  Created by Shawn James on 5/24/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import UIKit
import Cloudinary

class DetailViewController: UIViewController {
    
    // MARK: - Outlets & properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageBlur: UIVisualEffectView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var commentCountOrDescriptionLabel: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendCommentButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tutorialTextView: UITextView!
    // popover
    @IBOutlet var editPostPopOver: UIView!
    @IBOutlet weak var editPostButton: UIButton!
    @IBOutlet weak var editContentButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var tutorial: Tutorial?
    let modelController = ModelController()
    
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
        guard let tutorial = tutorial else { return }
        modelController.deleteTutorial(tutorial)
        titleLabel.text = "This Post Has Been Deleted"
    }
    
    @IBAction func sendCommentButtonTapped(_ sender: UIButton) {
        if UserDefaults.standard.bool(forKey: .isLoggedInKey) {
            guard let tutorial = tutorial,
                let text = commentTextField.text,
                !text.isEmpty else { return }
            
            modelController.createComment(Comment(author: UserDefaults.standard.string(forKey: .usernameKey)!,
                                                  text: text,
                                                  title: "\(tutorial.comments?.count ?? 0 + 1)"),
                                          for: tutorial)
            commentTextField.text = ""
        } else {
            // present alert because user is a guest and can't post
            let alert = UIAlertController(title: "You Must Be Logged in to Post Comments", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
        self.resignFirstResponder()
        self.view.endEditing(true)
        self.tableView.reloadData()
        if tutorial?.comments?.count != 1 {
            commentCountOrDescriptionLabel.text = "\(tutorial?.comments?.count ?? 0) Comments"
        } else {
            commentCountOrDescriptionLabel.text = "1 Comment"
        }
    }
    
    @IBAction func toggleSegmentedControl(_ sender: UISegmentedControl) {
        // FIXME: - would be nice to replace the views rather than just pop the tutorial view on top and move it back to the background
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            setUpTutorialView()
        case 1:
            // comments view
            tutorialTextView.alpha = 0
            tutorialTextView.text = ""
            tutorialTextView.superview?.sendSubviewToBack(tutorialTextView)
            // format this with comment count
            guard let tutorial = tutorial else { return }
            commentCountOrDescriptionLabel.text = "\(tutorial.comments?.count ?? 0) Comments"
        default:
            print("error: default value was triggered in toggleSegmentedControl() switch statement and shouldn't have been")
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
        setUpTutorialView()
        tableView.dataSource = self
        guard let tutorial = tutorial else { return }
        titleLabel.text = tutorial.title
        authorLabel.text = tutorial.author
        loadImage(for: tutorial.image)
    }
    
    private func setUpTutorialView() {
        // tutorial view
        tutorialTextView.alpha = 1
        guard let tutorial = tutorial else { return }
        tutorialTextView.text = tutorial.bodyText
        tutorialTextView.superview?.bringSubviewToFront(tutorialTextView)
        commentCountOrDescriptionLabel.text = "Description"
    }
    
    private func loadImage(for tutorialImagePath: String?) {
        guard let imageURL = tutorialImagePath else { return }
        
        let cloudinaryConfiguration = CLDConfiguration(cloudName: "dehqhte0i", apiKey: "959718959598545", secure: true)
        let cloudinaryControl = CLDCloudinary(configuration: cloudinaryConfiguration)
        
        cloudinaryControl.createDownloader().fetchImage(imageURL, { _ in
            // Handle progress
        }) { (responseImage, error) in
            if let error = error { print(error) }
            if let responseImage = responseImage {
                DispatchQueue.main.async {
                    self.imageView.image = responseImage
                    print("Image Was Returned To Detail View")
                }
            }
        }
    }
    
}

// for comments
extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let comments = tutorial?.comments else { return 0 }
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: .commentTableViewCellId, for: indexPath)
        guard let commentArray = tutorial?.comments?.allObjects as? [Comment] else { return cell }
        let sortedNewestFirst = commentArray.sorted { $0.title! > $1.title! }
        let commentAtIndexPath = sortedNewestFirst[indexPath.row]
        cell.textLabel?.text = (commentAtIndexPath as AnyObject).text
        cell.detailTextLabel?.text = (commentAtIndexPath as AnyObject).author
        return cell
    }
    
}
