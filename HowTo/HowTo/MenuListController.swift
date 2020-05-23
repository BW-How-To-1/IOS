//
//  MenuListController.swift
//  HowTo
//
//  Created by Shawn James on 5/23/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import UIKit

class MenuListController: UITableViewController {
    
    // MARK: - Properties
    var menuItems = ["Login", "SignUp", "Filter", "+ New Post", "Logout", "etc...", "My Posts"]
    private let cellReuseId = "cell"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseId)
        updateViews()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath)
        cell.textLabel?.text = menuItems[indexPath.row]
        cell.backgroundColor = .systemBlue
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont(name: "Avenir Next", size: 20)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // what should be done with user selection?
        switch indexPath.row {
        case 0:
            print("Login")
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
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                            NSAttributedString.Key.font: UIFont(name: "Avenir Next", size: 17)!]
        tableView.backgroundColor = .systemBlue
        navigationController?.navigationBar.barTintColor = .systemBlue
    }
    
}
