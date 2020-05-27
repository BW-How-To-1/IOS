//
//  MenuListController.swift
//  HowTo
//
//  Created by Shawn James on 5/23/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import UIKit

protocol MenuListDelegate {
    func menuItemPressed(buttonNumber: Int)
}

let notificationToUpdateViews = NSNotification.Name(rawValue: "updateViews")

class MenuListController: UITableViewController {
    
    // MARK: - Properties
    var menuLabels = [String]()
    var menuListDelegate: MenuListDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: .menuListControllerCellId)
        updateViews()
        initObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: notificationToUpdateViews, object: nil)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        menuLabels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: .menuListControllerCellId, for: indexPath)
        cell.textLabel?.text = menuLabels[indexPath.row]
        cell.backgroundColor = .systemBlue
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont(name: "Avenir Next", size: 20)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // what should be done with user selection when pressed?
        // FIXME: - this should all be refactored. it doesn't need a switch statement, it just needs to pass the index path.row into the buttonNumber parameter
        switch indexPath.row {
        case 0:
            // sort by...
            dismiss(animated: true) {
                self.menuListDelegate?.menuItemPressed(buttonNumber: 0)
            }
        case 1:
            // filter by...
            dismiss(animated: true) {
                self.menuListDelegate?.menuItemPressed(buttonNumber: 1)
            }
        case 2:
            // nothing yet...
            dismiss(animated: true) {
                self.menuListDelegate?.menuItemPressed(buttonNumber: 2)
            }
        case 3:
            // login / logout button
            dismiss(animated: true) {
                self.menuListDelegate?.menuItemPressed(buttonNumber: 3)
            }
        case 4:
            // create a new tutorial post
            dismiss(animated: true) {
                self.menuListDelegate?.menuItemPressed(buttonNumber: 4)
            }
        default:
            print("There is a menu item that does not do anything")
        }
    }
    
    // MARK: - Methods
    @objc private func updateViews() {
        let username = UserDefaults.standard.string(forKey: .usernameKey) ?? ""
        let isLoggedIn = UserDefaults.standard.bool(forKey: .isLoggedInKey)
        self.title = isLoggedIn == false ? "Using as Guest" : "Hello" + " " + username + "!"
        updateMenuLabels()
        let firstCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        firstCell?.accessibilityLabel = "firstMenuCell"
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                            NSAttributedString.Key.font: UIFont(name: "Avenir Next", size: 21)!]
        tableView.backgroundColor = .systemBlue
        navigationController?.navigationBar.barTintColor = .systemBlue
    }
    
    private func updateMenuLabels() {
        menuLabels = []
        // menuLabel 0
        menuLabels.append("Sort By...") // most commented / most liked etc...
        // menuLabel 1
        menuLabels.append("Filter By...")
        // menuLabel 2
        menuLabels.append("Placeholder...")
        // menuLabel 3
        menuLabels.append(UserDefaults.standard.bool(forKey: .isLoggedInKey) == true ? "Logout" : "Create an Account")
        // last (optional) menu label #4 - if logged in
        if UserDefaults.standard.bool(forKey: .isLoggedInKey) { menuLabels.append("Create a New Post") }
        
        
        tableView.reloadData()
    }

    
    private func initObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: notificationToUpdateViews, object: nil)
    }
    
}
