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
    
    let networkController = NetworkController()
    var addedStepCount: Int = 1
    
    var newTutorialTitle: String?
    var newTutorialDescription: String?
    var newStepString = ""
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions & Methods
    
    @IBAction func userStartingTryingToAddAStep(_ sender: UITextField) {
    }
    
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        // resets everything
        newStepString = ""
        addedStepsTextView.text = ""
        addedStepCount = 1
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        // TODO: save new post, send to coreData, send to database, update status label, dismiss to home screen, reload tableView to show new post
        // data is in the newStepString var
        // create object
        guard let newTutorialTitle = newTutorialTitle,
        let newTutorialDescription = newTutorialDescription else { return }
        let newTutorialObject = Tutorial(id: UUID().uuidString,
                                         title: newTutorialTitle,
                                         bodyText: newTutorialDescription + "\n" + newStepString,
                                         image: URL(string: "http://www.google.com/")!,
                                         likes: 0,
                                         author: UserDefaults.standard.string(forKey: .usernameKey)!, // we really want to make sure this exists, so we'll crash so we know something happened to it
                                         dateCreated: Date(),
                                         comments: [Comment(text: "", author: "")])
        
        // send to server
        networkController.postTutorial(for: newTutorialObject) { _ in
            print("attempted to post to server")
        }
            // maybe we want the tableView to reload here in completion handler? maybe not?
        
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
