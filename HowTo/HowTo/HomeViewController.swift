//
//  HomeViewController.swift
//  HowTo
//
//  Created by Shawn James on 5/22/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import UIKit
import SideMenu

class HomeViewController: UIViewController {
    
    // MARK: - Outlets & Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchControl: UISearchBar!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .systemBlue
        refreshControl.addTarget(self, action: #selector(fetchNewPosts), for: .valueChanged)
        return refreshControl
    }()
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    var menu: SideMenuNavigationController?
    let menuListController = MenuListController()
    // this is temporary and should be deleted
    var dummyCells = ["First", "Second", "Third"]
    
    // MARK: - Lifecycle & init's
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        menuListController.menuListDelegate = self
        onboardTheUserIfFirstLaunch()
    }
    
    // MARK: - Actions & Methods
    @IBAction func menuButtonTapped() {
        // presents the side menu
        present(menu!, animated: true)
    }
    
    private func updateViews() {
        tableView.dataSource = self
        tableView.backgroundColor = .black
        // nav bar
//        self.title = ""
        navigationController?.navigationBar.barTintColor = .systemBlue
        // add side menu to VC
        menu = SideMenuNavigationController(rootViewController: menuListController)
        // add ability to swipe side menu open and closed
        SideMenuManager.default.rightMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        menu?.presentationStyle = .viewSlideOutMenuOut
        menu?.statusBarEndAlpha = 0
        // acessibility ID's
        menuButton.accessibilityIdentifier = "menuButton"
        menu?.accessibilityLabel = "menu"
        // refreshControl
        tableView.refreshControl = refreshControl
    }
    
    private func onboardTheUserIfFirstLaunch() {
        guard UserDefaults.standard.bool(forKey: .firstLaunchKey) == false else { return }
        performSegue(withIdentifier: .showOnboardingSegueId, sender: self)
        UserDefaults.standard.set(true, forKey: .firstLaunchKey)
    }
    
    @objc private func fetchNewPosts() {
        // TODO: delete the contents of this method. this is just a dummy setup for UI
        print("User has pulled to refresh, fetchNewPosts() method has been called but does nothing yet")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.refreshControl.endRefreshing()
        }
    }
    
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dummyCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: .homeTableViewCellId, for: indexPath) as! HomeTableViewCell // FIXME: - crash this with a print or log if it fails
        cell.titleLabel.text = dummyCells[indexPath.row]
        cell.imageView1.image = UIImage(named: String(indexPath.row))
        cell.alertControllerDelegate = self
        return cell
    }
    
    
}

extension HomeViewController: MenuListDelegate {
    func menuItemPressed(buttonNumber: Int) {
        switch buttonNumber {
        case 0:
            // sort by...
            print("nothing yet...")
            // TODO: present an alert with sorting options
        case 1:
            // filter by...
            print("nothing yet...")
            // TODO: present an alert with filter options
        case 2:
            // nothing yet...
            print("nothing yet...")
        case 3:
            // login / signup
            self.performSegue(withIdentifier: .showOnboardingSegueId, sender: self)
        case 4:
            // create new post
            self.performSegue(withIdentifier: .showNewPostSegueId, sender: self)
        default:
            print("error: default case in menuItemPressed() was triggered")
        }
    }
    
}

extension HomeViewController: AlertControllerDelegate {
    func presentAlert(with text: String) {
        let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
}
