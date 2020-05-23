//
//  ViewController.swift
//  HowTo
//
//  Created by Shawn James on 5/22/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import UIKit
import SideMenu

class HomeViewController: UIViewController {
    
    // MARK: - Outlets & Properties
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    var menu: SideMenuNavigationController?
    
    // MARK: - Lifecycle & init's
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
        
    // MARK: - Actions & Methods
    @IBAction func menuButtonTapped() {
        // presents the side menu
        present(menu!, animated: true)
    }
    
    private func updateViews() {
        // nav bar
        self.title = ""
        navigationController?.navigationBar.barTintColor = UIColor.systemBlue
        // add side menu to VC
        menu = SideMenuNavigationController(rootViewController: UIViewController())
        // add ability to swipe side menu open and closed
        SideMenuManager.default.rightMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }

}

