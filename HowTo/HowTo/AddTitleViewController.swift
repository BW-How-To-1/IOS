//
//  AddTitleViewController.swift
//  HowTo
//
//  Created by Shawn James on 5/27/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import UIKit

class AddTitleViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    
    var newTutorialTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        guard let title = titleTextField.text, !title.isEmpty else { return }
        newTutorialTitle = title
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let addImageViewController = segue.destination as? AddImageViewController,
            let newTutorialTitle = newTutorialTitle else { return }
        
        addImageViewController.newTutorialTitle = newTutorialTitle
    }

}
