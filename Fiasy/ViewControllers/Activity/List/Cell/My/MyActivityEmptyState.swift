//
//  MyActivityEmptyState.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 9/11/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class MyActivityEmptyState: UITableViewCell {
    
    // MARK: - Actions -
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Life Cicle -
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let mutableAttrString = NSMutableAttributedString()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.alignment = .center
        
        mutableAttrString.append(NSAttributedString(string: LS(key: .EMPTY_MY_ACTIVITY_FIRST), attributes: [.font: UIFont.sfProTextSemibold(size: 16), .foregroundColor: #colorLiteral(red: 0.6273809075, green: 0.6274913549, blue: 0.6273739934, alpha: 1)]))
        mutableAttrString.append(NSAttributedString(string: LS(key: .EMPTY_MY_ACTIVITY_SECOND), attributes: [.font: UIFont.sfProTextSemibold(size: 16), .foregroundColor: #colorLiteral(red: 0.9187557101, green: 0.5817510486, blue: 0.2803534865, alpha: 1)]))
        mutableAttrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, mutableAttrString.length))
        descriptionLabel.attributedText = mutableAttrString
    }
    
    // MARK: - Actions -
    @IBAction func addNewActivityClicked(_ sender: Any) {
        if let vc = UIApplication.getTopMostViewController() as? ActivityViewController {
            vc.performSegue(withIdentifier: "sequeAddNewActivity", sender: nil)
        }
    }
}
