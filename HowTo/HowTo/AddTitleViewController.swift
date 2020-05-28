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
    
    var tutorialObjectBeingBuilt: Tutorial?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
