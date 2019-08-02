//
//  InstructionListTableCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/16/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class InstructionListTableCell: UITableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: - Properties -
    private var tableView: UITableView?
    private var indexPath: IndexPath?
    private var delegate: InstructionListDelegate?
    
    // MARK: - Life Cicle -
    override func prepareForReuse() {
        super.prepareForReuse()
        
        textView.text.removeAll()
    }
    
    // MARK: - Interface -
    func fillCell(_ tableView: UITableView, _ indexPath: IndexPath, _ delegate: InstructionListDelegate, _ text: String) {
        self.indexPath = indexPath
        self.tableView = tableView
        self.delegate = delegate
        
        nameLabel.text = "\(indexPath.row + 1)."
        textView.text = text
        textView.tag = indexPath.row
    }
        
    // MARK: - Actions -
    @IBAction func removeClicked(_ sender: Any) {
        guard let indexPath = self.indexPath else { return }
        self.delegate?.removeRow(indexPath)
    }
}

extension InstructionListTableCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        self.delegate?.fillInstructionText(tag: textView.tag, text: newText)
        return newText.count <= 200
    }
    
    func textViewDidChange(_ textView: UITextView) {
        UIView.performWithoutAnimation {
            guard let table = self.tableView else { return }
            table.beginUpdates()
            table.endUpdates()
        }
    }
}
