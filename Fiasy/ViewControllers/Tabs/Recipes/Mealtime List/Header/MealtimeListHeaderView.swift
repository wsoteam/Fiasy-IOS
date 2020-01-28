//
//  MealtimeListHeaderView.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 5/6/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class MealtimeListHeaderView: UITableViewHeaderFooterView, UITextFieldDelegate {

    // MARK: - Outlet -
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var generalStackView: UIStackView!
    @IBOutlet weak var cancelSearchButton: UIButton!
    @IBOutlet weak var textField: DesignableUITextField!
    
    // MARK: - Properties -
    static let height: CGFloat = 76.0
    private var secondDelegate: NutritionLikeDelegate?
    private var delegate: RecipeMealtimeDelegate?
    
    //MARK: - Interface -
    func fillHeader(delegate: RecipeMealtimeDelegate) {
        self.delegate = delegate
        
        textField.placeholder = LS(key: .SEARCH_FIELD_PLACEHOLDER)
        cancelSearchButton.setTitle(LS(key: .CANCEL), for: .normal)
    }
    
    func fillSecondHeader(delegate: NutritionLikeDelegate) {
        self.secondDelegate = delegate
        textField.placeholder = "Поиск по статьям"
    }
    
    //MARK: - Action -
    @IBAction func valueChange(_ sender: Any) {
        guard let text = self.textField.text else { return }
        delegate?.searchRecipes(name: text)
        self.secondDelegate?.searchRecipes(name: text)
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        if !cancelSearchButton.isHidden {
            UIView.animate(withDuration: 0.35, animations: {
                self.textField.text?.removeAll()
                self.rightConstraint.constant = 16
                self.cancelSearchButton.isHidden = true
                self.generalStackView.layoutIfNeeded()
            }) { (_) in
                self.endEditing(true)
                guard let text = self.textField.text else { return }
                self.delegate?.searchRecipes(name: text)
                self.secondDelegate?.searchRecipes(name: text)
            }
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        rightConstraint.constant = 8
        cancelSearchButton.showAnimated(in: generalStackView)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        rightConstraint.constant = 16
        cancelSearchButton.hideAnimated(in: generalStackView)
    }
}
