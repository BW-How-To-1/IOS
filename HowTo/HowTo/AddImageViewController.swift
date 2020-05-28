//
//  AddImageViewController.swift
//  HowTo
//
//  Created by Shawn James on 5/27/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import UIKit

class AddImageViewController: UIViewController {

    var newTutorialTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let addDescriptionViewController = segue.destination as? AddDescriptionViewController,
            let newTutorialTitle = newTutorialTitle else { return }
        
        addDescriptionViewController.newTutorialTitle = newTutorialTitle
    }

}
