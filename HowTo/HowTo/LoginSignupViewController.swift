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
        createObservers()
    }
    
    deinit {
        // stop listening to keyboard events
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    // MARK: - Actions & Methods
    @IBAction func submitButtonPressed(_ sender: UIButton) {
    }
    @IBAction func rememberMeButtonPressed(_ sender: UIButton) {
        // save username and pass
        UserDefaults.standard.set(username.text, forKey: .usernameKey)
        UserDefaults.standard.set(password.text, forKey: .passwordKey)
    }
    
    @IBAction func textWasEdited(_ sender: UITextField) {
        updateRememberMeButton()
    }
    
    private func updateViews() {
        navigationController?.isNavigationBarHidden = true
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
    
    func createObservers() {
        // listen for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        print("Keyboard will show: \(notification.name.rawValue)")
        view.frame.origin.y = -100
    }

}
