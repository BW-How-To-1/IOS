//
//  AddDescriptionViewController.swift
//  HowTo
//
//  Created by Shawn James on 5/25/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import UIKit

class AddDescriptionViewController: UIViewController {
    // MARK: - Outlets & properties
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var newTutorialTitle: String?
    var newTutorialImageURL: String?
    var newTutorialDescription: String?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions & methods
    // TODO: find way to clear "add a description..." placeholder when user wants to edit

    @IBAction func nextButtonPressed(_ sender: UIButton) {
        guard let description = descriptionTextView.text, !description.isEmpty else { return }
        newTutorialDescription = description
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let addStepsViewController = segue.destination as? AddStepsViewController,
            let newTutorialTitle = newTutorialTitle else { return }
        
        addStepsViewController.newTutorialImageURL = newTutorialImageURL
        addStepsViewController.newTutorialTitle = newTutorialTitle
        addStepsViewController.newTutorialDescription = newTutorialDescription
    }

}
