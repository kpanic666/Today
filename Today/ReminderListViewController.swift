//
//  ViewController.swift
//  Today
//
//  Created by Andrei Korikov on 21.11.2021.
//

import UIKit

class ReminderListViewController: UITableViewController {
    static let showDetailSegueIdentifier = "ShowReminderDetailSegue"
    private var reminderListDataSource: ReminderListDataSource?
    static let mainStoryboardName = "Main"
    static let detailViewControllerIdentifier = "ReminderDetailViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reminderListDataSource = ReminderListDataSource()
        tableView.dataSource = reminderListDataSource
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let navigationController = navigationController,
           navigationController.isToolbarHidden {
            navigationController.setToolbarHidden(false, animated: animated)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Self.showDetailSegueIdentifier,
           let destination = segue.destination as? ReminderDetailViewController,
           let cell = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell)
        {
            let rowIndex = indexPath.row
            guard let reminder = reminderListDataSource?.reminder(at: rowIndex) else {
                fatalError("Couldn't find data source for reminder list.")
            }
            destination.configure(with: reminder, editAction: { [weak self] reminder in
                self?.reminderListDataSource?.update(reminder, at: rowIndex)
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            })
        }
    }
    
    @IBAction func addButtonTriggered(_ sender: UIBarButtonItem) {
        addReminder()
    }
    
    private func addReminder() {
        let storyboard = UIStoryboard(name: Self.mainStoryboardName, bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: Self.detailViewControllerIdentifier) as! ReminderDetailViewController
        let reminder = Reminder(title: "New Reminder", dueDate: Date())
        detailVC.configure(with: reminder, isNew: true, addAction: { reminder in
            
        })
        let navigationController = UINavigationController(rootViewController: detailVC)
        present(navigationController, animated: true)
    }
}
