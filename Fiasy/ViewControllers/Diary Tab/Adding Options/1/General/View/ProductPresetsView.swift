//
//  ProductPresetsView.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 11/4/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class ProductPresetsView: UIView {
    
    // MARK: - Outlet -
    @IBOutlet weak var basketButton: UIButton!
    
    // MARK: - Properties -
    var delegate: ProductAddingDelegate?
    
    // MARK: - Interface -
    func fillView(count: Int) {
        let mutableAttrString = NSMutableAttributedString()
        mutableAttrString.append(NSAttributedString(string: "Выбрано:", attributes: [.font: UIFont.sfProTextSemibold(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1), .underlineStyle : NSUnderlineStyle.single.rawValue]))
        mutableAttrString.append(NSAttributedString(string: " \(count)", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)]))
        basketButton.setAttributedTitle(mutableAttrString, for: .normal)
    }
    
    // MARK: - Action -
    @IBAction func addClicked(_ sender: UIButton) {
        delegate?.showProgress(back: false)
    }
    
    @IBAction func basketClicked(_ sender: UIButton) {
        guard let _ = UIApplication.getTopMostViewController() as? BasketViewController else {
            delegate?.showBasket()
            return 
        }
    }
    
    // MARK: - Private -
    private func fetchCountPrefix(count: Int) -> String {
        switch count {
        case 1:
            return "продукт"
        case 2,3,4:
            return "продукта"
        default:
            return "продуктов"
        }
    }
}
