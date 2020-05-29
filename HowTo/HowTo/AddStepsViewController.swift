//
//  AddStepsViewController.swift
//  HowTo
//
//  Created by Shawn James on 5/25/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import UIKit

class AddStepsViewController: UIViewController {
    // MARK: - Outlets & properties
    @IBOutlet weak var addAStepTextField: UITextField!
    @IBOutlet weak var addedStepsTextView: UITextView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var addThisStepButton: UIButton!
    @IBOutlet weak var clearAllButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    let networkController = NetworkController()
    var addedStepCount: Int = 1
    
    var newTutorialTitle: String?
    var newTutorialImageURL: String?
    var newTutorialDescription: String?
    var newStepString = ""
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        clearAllButton.alpha = 0
        doneButton.alpha = 0
        statusLabel.text = ""
        addThisStepButton.alpha = 0
    }
    
    // MARK: - Actions & Methods
    
    @IBAction func userStartingTryingToAddAStep(_ sender: UITextField) {
        addThisStepButton.alpha = 1
    }
    
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        // resets everything
        newStepString = ""
        addedStepsTextView.text = ""
        addedStepCount = 1
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        guard let newTutorialTitle = newTutorialTitle,
        let newTutorialDescription = newTutorialDescription else { return }
        self.statusLabel.text = "Creating..."
        // create object
        let newTutorialObject = Tutorial(author: UserDefaults.standard.string(forKey: .usernameKey)!, // this should definitely be here or they should be on this screen
                                         title: newTutorialTitle,
                                         bodyText: newTutorialDescription + "\n" + "\n" + addedStepsTextView.text,
                                         image: newTutorialImageURL)
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            print("Error saving tutorial object into CoreData: \(error)")
        }
        // send to server
        networkController.postTutorial(for: newTutorialObject) { _ in
            print("attempted to post to server")
            self.statusLabel.text = "Success!"
            self.statusLabel.textColor = .systemGreen
        }
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addThisStepButtonPressed(_ sender: UIButton) {
        guard let textInput = addAStepTextField.text, !textInput.isEmpty else { return }
        // lists steps out in a numbered list
        addedStepsTextView.text = ""
        newStepString.append("\(addedStepCount). \(textInput)\n")
        addedStepsTextView.text = newStepString
        addAStepTextField.text = ""
        addedStepCount += 1
        // flash scroll indicators to show something was added and view can be scrolled
        // FIXME: - why doesn't this work?
        addedStepsTextView.flashScrollIndicators()
        clearAllButton.alpha = 1
        doneButton.alpha = 1
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
