//
//  EditDateCell.swift
//  Today
//
//  Created by Andrei Korikov on 27.11.2021.
//

import UIKit

class EditDateCell: UITableViewCell {
    @IBOutlet var datePicker: UIDatePicker!
    
    func configure(date: Date) {
        datePicker.date = date
    }
}
