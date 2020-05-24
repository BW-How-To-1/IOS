//
//  LoginSignupViewController.swift
//  HowTo
//
//  Created by Shawn James on 5/23/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import UIKit

class LoginSignupViewController: UIViewController {
    // MARK: - Outlets & Properties
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var rememberMeButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    // MARK: - Actions & Methods
    @IBAction func submitButtonPressed(_ sender: UIButton) {
    }
    @IBAction func rememberMeButtonPressed(_ sender: UIButton) {
        UserDefaults.standard.set(username.text, forKey: .usernameKey)
        UserDefaults.standard.set(password.text, forKey: .passwordKey)
    }
    
    @IBAction func textWasEdited(_ sender: UITextField) {
        updateRememberMeButton()
    }
    
    private func updateViews() {
        autofillTextFields()
        updateRememberMeButton()
        guard let logoImage = UIImage(named: "0") else { return }
        imageView.image = logoImage.roundedImage
    }
    
    private func autofillTextFields() {
        guard let rememberUsername = UserDefaults.standard.object(forKey: .usernameKey) as? String,
            let rememberPassword = UserDefaults.standard.object(forKey: .passwordKey) as? String else { return }
        
        username.text = rememberUsername
        password.text = rememberPassword
    }
    
    func updateRememberMeButton() {
        // should rememberMeButton be selected
        if username.text == UserDefaults.standard.object(forKey: .usernameKey) as? String
            && password.text == UserDefaults.standard.object(forKey: .passwordKey) as? String {
            rememberMeButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
        } else {
            rememberMeButton.setImage(UIImage(systemName: "square"), for: .normal)
        }
    }

}
