//
//  MenuCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 10/4/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var clickedButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var radioButton: RadioButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Properties -
    private var indexPath: IndexPath?
    private var delegate: ProductDetailsDelegate?
    private var secondDelegate: DishDetailsDelegate?
    
    // MARK: - Interface -
    func fillCell(_ indexPath: IndexPath, selectedTitle: String, delegate: ProductDetailsDelegate?) {
        self.delegate = delegate
        self.indexPath = indexPath
        bottomView.isHidden = true
        radioButton.isOn = false
        if let _ = delegate, let button = self.clickedButton {
            button.isHidden = false
        }
        switch indexPath.row {
        case 0:
            if selectedTitle == LS(key: .BREAKFAST) {
                radioButton.isOn = true
            }
            titleLabel.text = LS(key: .BREAKFAST)
        case 1:
            if selectedTitle == LS(key: .LUNCH) {
                radioButton.isOn = true
            }
            titleLabel.text = LS(key: .LUNCH)
        case 2:
            if selectedTitle == LS(key: .DINNER) {
                radioButton.isOn = true
            }
            titleLabel.text = LS(key: .DINNER)
        case 3:
            if selectedTitle == LS(key: .SNACK) {
                radioButton.isOn = true
            }
            titleLabel.text = LS(key: .SNACK)
            bottomView.isHidden = false
        default:
            break
        }
    }
    
    func fillSecondCell(_ indexPath: IndexPath, selectedTitle: String, delegate: DishDetailsDelegate?) {
        self.secondDelegate = delegate
        self.indexPath = indexPath
        bottomView.isHidden = true
        radioButton.isOn = false
        if let _ = delegate, let button = self.clickedButton {
            button.isHidden = false
        }
        switch indexPath.row {
        case 0:
            if selectedTitle == LS(key: .BREAKFAST) {
                radioButton.isOn = true
            }
            titleLabel.text = LS(key: .BREAKFAST)
        case 1:
            if selectedTitle == LS(key: .LUNCH) {
                radioButton.isOn = true
            }
            titleLabel.text = LS(key: .LUNCH)
        case 2:
            if selectedTitle == LS(key: .DINNER) {
                radioButton.isOn = true
            }
            titleLabel.text = LS(key: .DINNER)
        case 3:
            if selectedTitle == LS(key: .SNACK) {
                radioButton.isOn = true
            }
            titleLabel.text = LS(key: .SNACK)
            bottomView.isHidden = false
        default:
            break
        }
    }
    
    // MARK: - Actions -
    @IBAction func typeClicked(_ sender: Any) {
        guard let index = self.indexPath else { return }
        delegate?.menuClicked(indexPath: index)
        secondDelegate?.menuClicked(indexPath: index)
    }
}

