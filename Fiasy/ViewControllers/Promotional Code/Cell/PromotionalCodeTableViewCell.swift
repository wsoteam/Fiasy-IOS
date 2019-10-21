//
//  PromotionalCodeTableViewCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 9/21/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class PromotionalCodeTableViewCell: UITableViewCell {
    
    // MARK: - Actions -
    @IBAction func showContainerClicked(_ sender: Any) {
        if let vc = UIApplication.getTopMostViewController() as? PromotionalCodeViewController {
            vc.codeTextField.text?.removeAll()
            vc.activeButton.backgroundColor = #colorLiteral(red: 0.741094768, green: 0.7412236333, blue: 0.7410866618, alpha: 1)
            vc.defaultLabel.text = "Введите ваш промокод"
            vc.separatorView.backgroundColor = #colorLiteral(red: 0.9293106198, green: 0.9294700027, blue: 0.9293007255, alpha: 1)
            vc.defaultLabel.textColor = #colorLiteral(red: 0.6313020587, green: 0.6314132214, blue: 0.6312951446, alpha: 1)
            vc.activeButton.isEnabled = (vc.codeTextField.text?.isEmpty ?? true) ? false : true
            vc.codeTextField.becomeFirstResponder()
        }
    }
}
