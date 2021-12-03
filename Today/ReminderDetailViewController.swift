//
//  ReminderDetailViewController.swift
//  Today
//
//  Created by Andrei Korikov on 24.11.2021.
//

import UIKit

class ReminderDetailViewController: UITableViewController {
    typealias ReminderChangeAction = (Reminder) -> Void
    
    private var reminder: Reminder?
    private var dataSource: UITableViewDataSource?
    private var tempReminder: Reminder?
    private var reminderEditAction: ReminderChangeAction?
    private var reminderAddAction: ReminderChangeAction?
    private var isNew = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setEditing(isNew, animated: false)
        navigationItem.setRightBarButton(editButtonItem, animated: false)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ReminderDetailEditDataSource.dateLabelCellIdentifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let navigationController = navigationController,
           !navigationController.isToolbarHidden {
            navigationController.setToolbarHidden(true, animated: animated)
        }
    }
    
    func configure(
        with reminder: Reminder,
        isNew: Bool = false,
        addAction: ReminderChangeAction? = nil,
        editAction: ReminderChangeAction? = nil
    ) {
        self.reminder = reminder
        self.isNew = isNew
        self.reminderAddAction = addAction
        self.reminderEditAction = editAction
        if isViewLoaded {
            setEditing(isNew, animated: false)
        }
    }
    
    fileprivate func transitionToViewMode(_ reminder: Reminder) {
        if isNew {
            let addReminder = tempReminder ?? reminder
            dismiss(animated: true) {
                self.reminderAddAction?(addReminder)
            }
            return
        }
        if let tempReminder = tempReminder {
            self.reminder = tempReminder
            self.tempReminder = nil
            reminderEditAction?(tempReminder)
            dataSource = ReminderDetailViewDataSource(reminder: tempReminder)
        } else {
            dataSource = ReminderDetailViewDataSource(reminder: reminder)
        }
        
        navigationItem.title = "View Reminder"
        navigationItem.leftBarButtonItem = nil
        editButtonItem.isEnabled = true
    }
    
    fileprivate func transitionToEditMode(_ reminder: Reminder) {
        dataSource = ReminderDetailEditDataSource(reminder: reminder) { reminder in
            self.editButtonItem.isEnabled = true
            self.tempReminder = reminder
        }
        navigationItem.title = isNew ? "Add Reminder" : "Edit Reminder"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTrigger))
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        guard let reminder = reminder else {
            fatalError("No reminder found for detail view")
        }
        
        if editing {
            transitionToEditMode(reminder)
        } else {
            transitionToViewMode(reminder)
        }
        
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
    
    @objc
    func cancelButtonTrigger() {
        if isNew {
            dismiss(animated: true)
        } else {
            tempReminder = nil
            setEditing(false, animated: true)
        }
    }
}
