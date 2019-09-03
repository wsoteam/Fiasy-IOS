//
//  EditProfileFooterView.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/14/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class EditProfileFooterView: UITableViewHeaderFooterView {

    // MARK: - Properties -
    static var height: CGFloat = 120.0
    private var delegate: EditProfileDisplayDelegate?
    private var secondDelegate: CalorieIntakeDelegate?
    
    // MARK: - Interface -
    func fillFooter(delegate: EditProfileDisplayDelegate) {
        self.delegate = delegate
    }
    
    func fillSecondFooter(delegate: CalorieIntakeDelegate) {
        self.secondDelegate = delegate
    }
    
    @IBAction func saveClicked(_ sender: Any) {
        if let delegate = self.delegate {
            delegate.saveAllFields()
        }
        
        if let secondDelegate = self.secondDelegate {
            secondDelegate.saveAllFields()
        }
    }
}
