//
//  EditNotesCell.swift
//  Today
//
//  Created by Andrei Korikov on 27.11.2021.
//

import UIKit

class EditNotesCell: UITableViewCell {
    @IBOutlet var notesTextView: UITextView!
    
    func configure(notes: String?) {
        notesTextView.text = notes
    }

}
