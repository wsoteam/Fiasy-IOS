//
//  TemplateListTableCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 12/27/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import DropDown

class TemplateListTableCell: UITableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var topSeparatorView: UIView!
    @IBOutlet weak var productCountLabel: UILabel!
    @IBOutlet weak var titleNameLabel: UILabel!
    
    // MARK: - Properties -
    private var indexPath: IndexPath?
    private var dropDown = DropDown()
    private var delegate: TemplateViewDelegate?
    
    // MARK: - Interface -
    func fillCell(_ template: Template, delegate: TemplateViewDelegate, indexPath: IndexPath) {
        self.indexPath = indexPath
        self.delegate = delegate
        fillDropDown()
        titleNameLabel.text = template.name
        productCountLabel.text = "\(template.products.count) \(fetchCountPrefix(count: template.products.count))"
        topSeparatorView.isHidden = indexPath.row != 0
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
    
    private func fillDropDown() {
        DropDown.appearance().IBcornerRadius = 10
        DropDown.appearance().textFont = UIFont.sfProTextMedium(size: 15)
        if dropDown.dataSource.isEmpty {
            dropDown.dataSource.append("     \(LS(key: .CREATE_STEP_TITLE_36))")
            dropDown.dataSource.append("     \(LS(key: .DELETE))")
        }
        
        dropDown.anchorView = containerView
        dropDown.textColor = #colorLiteral(red: 0.2431066334, green: 0.2431548834, blue: 0.2431036532, alpha: 1)
        dropDown.selectedTextColor = #colorLiteral(red: 0.2431066334, green: 0.2431548834, blue: 0.2431036532, alpha: 1)
        dropDown.selectionBackgroundColor = .clear
        dropDown.backgroundColor = #colorLiteral(red: 0.9998915792, green: 1, blue: 0.9998809695, alpha: 1)
        dropDown.shadowColor = #colorLiteral(red: 0.2588235294, green: 0.2588235294, blue: 0.2588235294, alpha: 0.7022146451)
        DropDown.appearance().cellHeight = 50
        dropDown.bottomOffset = CGPoint(x: 0, y: 50)
        
        dropDown.cornerRadius = 8.0
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let strongSelf = self, let indexPath = strongSelf.indexPath else { return }
            switch index {
            case 0:
                strongSelf.delegate?.editProduct(indexPath)
            case 1:
                strongSelf.delegate?.removeSomeProduct(indexPath)
            default:
                break
            }
        }
    }
    
    private func getPreferredLocale() -> Locale {
        guard let preferredIdentifier = Locale.preferredLanguages.first else {
            return Locale.current
        }
        return Locale(identifier: preferredIdentifier)
    }
    
    // MARK: - Actions -
    @IBAction func moreClicked(_ sender: Any) {
        dropDown.show()
//        guard let index = self.indexPath else { return }
//        self.delegate?.moreClicked(indexPath: index)
    }
}
