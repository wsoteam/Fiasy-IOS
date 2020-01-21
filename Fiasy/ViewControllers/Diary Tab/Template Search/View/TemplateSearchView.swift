//
//  TemplateSearchView.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 12/26/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class TemplateSearchView: UIView {
    
    // MARK: - Outlet -
    @IBOutlet weak var addDiaryButton: UIButton!
    @IBOutlet weak var basketButton: UIButton!
    
    // MARK: - Properties -
    var delegate: ProductAddingDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //addDiaryButton.setTitle(LS(key: .ADD_TO_DIARY), for: .normal)
    }
    
    // MARK: - Interface -
    func fillView(count: Int) {
        let mutableAttrString = NSMutableAttributedString()
//        mutableAttrString.append(NSAttributedString(string: "\(LS(key: .SELECTED_BASKET)):", attributes: [.font: UIFont.sfProTextSemibold(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//        
//        
        mutableAttrString.append(NSAttributedString(string: "\(count) \(fetchCountPrefix(count: count))", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
        basketButton.setAttributedTitle(mutableAttrString, for: .normal)
    }
    
    // MARK: - Action -
    @IBAction func addClicked(_ sender: UIButton) {
        delegate?.showBasket()
    }
    
    // MARK: - Private -
    private func fetchCountPrefix(count: Int) -> String {
        if getPreferredLocale().languageCode == "ru" {
            
            switch count {
            case 1:
                return "продукт"
            case 2,3,4:
                return "продукта"
            default:
                return "продуктов"
            }
        } else {
            return LS(key: .COUNT_PRODUCTS)
        }
    }
    
    private func getPreferredLocale() -> Locale {
        guard let preferredIdentifier = Locale.preferredLanguages.first else {
            return Locale.current
        }
        return Locale(identifier: preferredIdentifier)
    }
}
