//
//  SecondRecipeCheckTableVIewCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/17/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class SecondRecipeCheckTableVIewCell: UITableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var nameWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: - Interface -
    func fillCell(flow: AddRecipeFlow, _ indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            if flow.allProduct.indices.contains(indexPath.row) {
                nameLabel.text = ""
                nameWidthConstraint.constant = 0
                textView.text = flow.allProduct[indexPath.row].name
            }
        case 2:
            nameWidthConstraint.constant = 20
            nameLabel.text = "\(indexPath.row + 1)."
            if flow.instructionsList.indices.contains(indexPath.row) {
                var text: String = ""
                let fullNameArr2 = (flow.instructionsList[indexPath.row] ?? "").split{$0 == " "}.map(String.init)
                for item in fullNameArr2 where !item.isEmpty {
                    text = text.isEmpty ? item : text + " \(item)"
                }
                textView.text = text
            }
        default:
            break
        }
        textView.isUserInteractionEnabled = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
    }
}
