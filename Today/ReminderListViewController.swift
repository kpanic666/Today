//
//  ViewController.swift
//  Today
//
//  Created by Andrei Korikov on 21.11.2021.
//

import UIKit

class ReminderListViewController: UITableViewController {
    @IBOutlet var filterSegmentedControl: UISegmentedControl!
    @IBOutlet var progressContainerView: UIView!
    @IBOutlet var percentCompleteView: UIView!
    @IBOutlet var percentIncompleteView: UIView!
    @IBOutlet var percentCompleteHeight: NSLayoutConstraint!
    
    static let showDetailSegueIdentifier = "ShowReminderDetailSegue"
    private var reminderListDataSource: ReminderListDataSource?
    static let mainStoryboardName = "Main"
    static let detailViewControllerIdentifier = "ReminderDetailViewController"
    
    private var filter: ReminderListDataSource.Filter {
        ReminderListDataSource.Filter(rawValue: filterSegmentedControl.selectedSegmentIndex) ?? .today
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reminderListDataSource = ReminderListDataSource(reminderCompletedAction: { reminderIndex in
            self.tableView.reloadRows(at: [IndexPath(row: reminderIndex, section: 0)], with: .automatic)
            self.refreshProgressView()
        }, reminderDeletedAction: {
            self.refreshProgressView()
        })
        tableView.dataSource = reminderListDataSource
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let radius = view.bounds.size.width * 0.5 * 0.7
        progressContainerView.layer.cornerRadius = radius
        progressContainerView.layer.masksToBounds = true
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
                self?.tableView.reloadData()
            })
        }
    }
    
    @IBAction func addButtonTriggered(_ sender: UIBarButtonItem) {
        addReminder()
    }
    
    @IBAction func segmentControlChanged(_ sender: UISegmentedControl) {
        reminderListDataSource?.filter = filter
        tableView.reloadData()
        self.refreshProgressView()
    }
    
    private func addReminder() {
        let storyboard = UIStoryboard(name: Self.mainStoryboardName, bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: Self.detailViewControllerIdentifier) as! ReminderDetailViewController
        let reminder = Reminder(id: UUID().uuidString, title: "New Reminder", dueDate: Date())
        detailVC.configure(with: reminder, isNew: true, addAction: { reminder in
            if let index = self.reminderListDataSource?.add(reminder) {
                self.tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                self.refreshProgressView()
            }
        })
        let navigationController = UINavigationController(rootViewController: detailVC)
        present(navigationController, animated: true)
    }
    
    private func refreshProgressView() {
        guard let percentComplete = reminderListDataSource?.percentComplete else {
            return
        }
        let totalHeight = progressContainerView.bounds.size.height
        percentCompleteHeight.constant = totalHeight * CGFloat(percentComplete)
        UIView.animate(withDuration: 0.2) {
            self.progressContainerView.layoutSubviews()
        }
    }
}
