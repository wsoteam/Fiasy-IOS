//
//  ProductSearchHeaderView.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 11/5/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class ProductSearchHeaderView: UITableViewHeaderFooterView, UITextFieldDelegate {
    
    // MARK: - Outlet -
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var generalStackView: UIStackView!
    @IBOutlet weak var cancelSearchButton: UIButton!
    @IBOutlet weak var textField: DesignableUITextField!
    
//    // MARK: - Interface -
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cancelSearchButton.titleLabel?.minimumScaleFactor = 0.5
        cancelSearchButton.titleLabel?.adjustsFontSizeToFitWidth = true
        textField.placeholder = LS(key: .SEARCH)
        cancelSearchButton.setTitle(LS(key: .CANCEL), for: .normal)
    }
    
    // MARK: - Properties -
    static let height: CGFloat = 76.0
    private var delegate: ProductSearchDelegate?
    
    //MARK: - Interface -
    func fillHeader(delegate: ProductSearchDelegate) {
        self.delegate = delegate
    }
    
    //MARK: - Action -
    @IBAction func valueChange(_ sender: Any) {
        guard let text = self.textField.text else { return }
        self.delegate?.searchSuggestionItem(text: text)
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        delegate?.changeScreenState(state: .list)
        
        if !cancelSearchButton.isHidden {
            UIView.animate(withDuration: 0.35, animations: {
                self.textField.text?.removeAll()
                self.rightConstraint.constant = 16
                self.cancelSearchButton.isHidden = true
                self.generalStackView.layoutIfNeeded()
            }) { (_) in
                self.endEditing(true)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        self.delegate?.searchItem(text: text)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        rightConstraint.constant = 8
        //cancelSearchButton.fadeIn()
        cancelSearchButton.showAnimated(in: generalStackView)
        self.delegate?.changeScreenState(state: .search)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        rightConstraint.constant = 16
        cancelSearchButton.hideAnimated(in: generalStackView)
    }
    
//    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
//        searchBar.setShowsCancelButton(true, animated: true)
//        return true
//    }
//    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.setShowsCancelButton(false, animated: true)
//        delegate?.changeScreenState(state: .list)
//        endEditing(false)
//    }
//    
    // MARK: - Private -
//    private func setupSearcBar() {
//        if let view = searchBar.subviews.first {
//            view.clipsToBounds = false
//            view.cornerRadius = 16
//            view.IBshadowOffset = CGSize(width: 1, height: 1)
//            view.IBshadowOpacity = 3
//            view.IBshadowRadius = 3
//            view.IBshadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1952131886)
//        }
//        searchBar.setBackgroundImage(UIImage(), for: UIBarPosition(rawValue: 0)!, barMetrics: .default)
//        if #available(iOS 11.0, *) {
//            searchBar.tintColor = #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)
//            if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
//                textfield.textColor = #colorLiteral(red: 0.2431066334, green: 0.2431548834, blue: 0.2431036532, alpha: 1)
//                textfield.attributedPlaceholder = NSAttributedString(string: "Поиск", attributes: [NSAttributedString.Key.font: UIFont.sfProTextMedium(size: 15), NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.7293327451, green: 0.7292386889, blue: 0.7416192293, alpha: 1)])
//                textfield.backgroundColor = .white
//            }
//        }
//    }
}
