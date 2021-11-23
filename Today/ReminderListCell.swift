//
//  ReminderListCell.swift
//  Today
//
//  Created by Andrei Korikov on 23.11.2021.
//

import UIKit

class ReminderListCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var doneButton: UIButton!
    
    typealias DoneButtonAction = () -> Void
    
    var doneButtonAction: DoneButtonAction?
    
    @IBAction func doneButtonTriggered(_ sender: UIButton) {
        doneButtonAction?()
    }
}
