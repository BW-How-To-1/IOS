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
    @IBOutlet weak var nextButton: UIButton!
    
    var newTutorialTitle: String?
    var newTutorialImageURL: String?
    var newTutorialDescription: String?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.descriptionTextView.text = ""
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.nextButton.alpha = 1
        }
    }
    
    // MARK: - Actions & methods
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
