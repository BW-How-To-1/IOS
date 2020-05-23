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

class MenuListController: UITableViewController {
    
    // MARK: - Properties
    var menuLabels = [String]()
    var menuListDelegate: MenuListDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: .menuListControllerCellId)
        updateViews()
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
        switch indexPath.row {
        case 0:
            // login / signup button
            dismiss(animated: true) {
                self.menuListDelegate?.menuItemPressed(buttonNumber: 0)
            }
        case 1:
            print("SignUp")
        case 2:
            print("Filter")
        case 3:
            print("+ New Post")
        case 4:
            print("Logout")
        case 5:
            print("etc...")
        default:
            print("There is a menu item that does not do anything")
        }
    }
    
    // MARK: - Methods
    private func updateViews() {
        self.title = "Not Logged In"
        updateMenuLabels()
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                            NSAttributedString.Key.font: UIFont(name: "Avenir Next", size: 17)!]
        tableView.backgroundColor = .systemBlue
        navigationController?.navigationBar.barTintColor = .systemBlue
    }
    
    private func updateMenuLabels() {
        // menuLabel 1
        menuLabels.append(UserDefaults.standard.bool(forKey: .isLoggedInKey) == true ? "Logout" : "Login / Signup")
        // menuLabel 2
        // menuLabel 3
        // menuLabel 4
        // menuLabel 5
    }
    
}
