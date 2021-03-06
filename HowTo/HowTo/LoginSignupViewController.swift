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
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var rememberMeButton: UIButton!
    @IBOutlet weak var textFieldBackgroundView: UIView!
    // keep updating this text with errors or successes for the user to see what's going on
    @IBOutlet weak var statusLabel: UILabel!
    
    var loginSignupController = LoginSignupController.shared
    var isLoggingIn: Bool = false
        
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
        // if login was successful then run the following. Otherwise, present error to user
        UserDefaults.standard.set(true, forKey: .isLoggedInKey)
        presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: notificationToUpdateViews, object: nil)
        
        switch isLoggingIn {
        case true:
            statusLabel.text = "Logging In"
            loginSignupController.logIn(as: User(username: username.text, password: password.text)) { _ in
                // can add status updates
//                self.statusLabel.text = "Success!"
//                self.statusLabel.textColor = .systemGreen
            }
        case false:
            statusLabel.text = "Logging In"
            loginSignupController.signUp(as: User(username: username.text, password: password.text)) { _ in
                // can add status updates
//                self.statusLabel.text = "Success!"
//                self.statusLabel.textColor = .systemGreen
            }
        }
        
    }
    
    @IBAction func rememberMeButtonPressed(_ sender: UIButton) {
        // save username and pass
        UserDefaults.standard.set(username.text, forKey: .usernameKey)
        UserDefaults.standard.set(password.text, forKey: .passwordKey)
        rememberMeButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
    }
    
    @IBAction func textWasEdited(_ sender: UITextField) {
        updateRememberMeButton()
    }
    
    @IBAction func textBeganEdited(_ sender: UITextField) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.rememberMeButton.alpha = 1
        })
    }
    
    
    private func updateViews() {
        navigationController?.isNavigationBarHidden = true
        autofillTextFields()
        updateRememberMeButton()
        guard let logoImage = UIImage(named: "monkey") else { return }
        imageView.image = logoImage.roundedImage
        submitButton.layer.cornerRadius = 5
        textFieldBackgroundView.layer.cornerRadius = 5
        textFieldBackgroundView.layer.shadowColor = UIColor.black.cgColor
        textFieldBackgroundView.layer.shadowOpacity = 1
        textFieldBackgroundView.layer.shadowOffset = .zero
        textFieldBackgroundView.layer.shadowRadius = 10
        rememberMeButton.alpha = 0
        statusLabel.text = ""
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
