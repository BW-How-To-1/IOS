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
    @IBOutlet var editPostPopOver: UIView!
    @IBOutlet weak var editPostButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    // MARK: - Acitons & Methods
    @IBAction func editPostButtonTapped(_ sender: UIButton) {
        // TODO: guard to make sure user = author, otherwise they can't use or see this button
        self.view.addSubview(editPostPopOver)
        editPostPopOver.center = editPostButton.center
        editPostPopOver.center.y = editPostButton.center.y + 71
    }
    
    @IBAction func editPostPopOverBackButtonPressed(_ sender: UIButton) {
        self.editPostPopOver.removeFromSuperview()
    }
    
    private func updateViews() {
        self.editPostPopOver.layer.cornerRadius = 10
        // TODO: if user == author, then show edit post button, otherwise hide it
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
