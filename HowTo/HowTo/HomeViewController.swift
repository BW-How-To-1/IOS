//
//  HomeViewController.swift
//  HowTo
//
//  Created by Shawn James on 5/22/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import UIKit
import SideMenu
import CoreData

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
    let networkController = NetworkController()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Tutorial> = {
        let fetchRequest: NSFetchRequest<Tutorial> = Tutorial.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        let mainContext = CoreDataStack.shared.mainContext
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: mainContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error Fetching -> HomeViewController in fetchedResultsController: \(error)")
        }
        return fetchedResultsController
    }()
    
    // MARK: - Lifecycle & init's
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        menuListController.menuListDelegate = self
        searchControl.delegate = self
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
        refreshControl.accessibilityLabel = "refreshControl"
        // refreshControl
        tableView.refreshControl = refreshControl
    }
    
    private func onboardTheUserIfFirstLaunch() {
        guard UserDefaults.standard.bool(forKey: .firstLaunchKey) == false else { return }
        performSegue(withIdentifier: .showOnboardingSegueId, sender: self)
        UserDefaults.standard.set(true, forKey: .firstLaunchKey)
    }
    
    @objc private func fetchNewPosts() {
        networkController.getTutorials { _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
        
        print("User has pulled to refresh, fetchNewPosts() method has been called but does nothing yet")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.refreshControl.endRefreshing()
        }
    }
    
    private func sortBy(_ keyToSortBy: String) {
        self.fetchedResultsController.fetchRequest.sortDescriptors = [NSSortDescriptor(key: keyToSortBy, ascending: false)]
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            print("Error Fetching -> HomeViewController in sortBy method: \(error)")
        }
        self.tableView.reloadData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == .showDetailVCSegueId {
            guard let detailViewController = segue.destination as? DetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            detailViewController.tutorial = fetchedResultsController.object(at: indexPath)
        }
    }
    
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchedResultsController.sections![section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: .homeTableViewCellId, for: indexPath) as! HomeTableViewCell // FIXME: - crash this with a print or log if it fails
        cell.tutorial = fetchedResultsController.object(at: indexPath)
        cell.alertControllerDelegate = self
        // change selected color
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.systemYellow
        cell.selectedBackgroundView = backgroundView
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension HomeViewController: MenuListDelegate {
    func menuItemPressed(buttonNumber: Int) {
        switch buttonNumber {
        case 0:
            sortBy("likes")
        case 1:
            sortBy("dateCreated")
        case 2:
            guard let numberOfRows = fetchedResultsController.fetchedObjects?.count,
                numberOfRows != 0,
                numberOfRows != 1 else { return }
            let randomCellRow = Int.random(in: 0..<numberOfRows)
            let indexPath = IndexPath(row: randomCellRow, section: 0)
            self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
            self.tableView.delegate?.tableView!(tableView, didSelectRowAt: indexPath)
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

extension HomeViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchTerm = searchBar.text {
            
            let predicate = NSPredicate(format: "(title contains[cd] %@)", searchTerm)
            fetchedResultsController.fetchRequest.predicate = predicate
            
            do {
                try fetchedResultsController.performFetch()
                tableView.reloadData()
                self.resignFirstResponder() // FIXME: - why doesn't this dismiss the keyboard
            } catch let err as NSError {
                print(err)
            }
        }
        if searchBar.text == "" {
            fetchedResultsController.fetchRequest.predicate = nil
            
            do {
                try fetchedResultsController.performFetch()
                tableView.reloadData()
            } catch let err as NSError {
                print(err)
            }
        }
    }
    
}
