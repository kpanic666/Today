//
//  EditTitleCell.swift
//  Today
//
//  Created by Andrei Korikov on 27.11.2021.
//

import UIKit

class EditTitleCell: UITableViewCell {
    @IBOutlet var titleTextField: UITextField!

    func configure(title: String) {
        titleTextField.text = title
    }
}
