//
//  EditTitleCell.swift
//  Today
//
//  Created by Andrei Korikov on 27.11.2021.
//

import UIKit

class EditTitleCell: UITableViewCell {
    @IBOutlet var titleTextField: UITextField!
    
    typealias TitleChangeAction = (String) -> Void
    
    private var titleChangeAction: TitleChangeAction?

    func configure(title: String, changeAction: @escaping TitleChangeAction) {
        titleTextField.text = title
        titleChangeAction = changeAction
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleTextField.delegate = self
    }
}

extension EditTitleCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let originalText = textField.text {
            let title = (originalText as NSString).replacingCharacters(in: range, with: string)
            titleChangeAction?(title)
        }
        return true
    }
}
