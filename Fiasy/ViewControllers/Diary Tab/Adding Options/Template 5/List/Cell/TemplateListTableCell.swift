//
//  TemplateListTableCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 12/27/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class TemplateListTableCell: UITableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var topSeparatorView: UIView!
    @IBOutlet weak var productCountLabel: UILabel!
    @IBOutlet weak var titleNameLabel: UILabel!
    
    // MARK: - Properties -
    private var indexPath: IndexPath?
    private var delegate: TemplateViewDelegate?
    
    // MARK: - Interface -
    func fillCell(_ template: Template, delegate: TemplateViewDelegate, indexPath: IndexPath) {
        self.indexPath = indexPath
        self.delegate = delegate
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
    
    private func getPreferredLocale() -> Locale {
        guard let preferredIdentifier = Locale.preferredLanguages.first else {
            return Locale.current
        }
        return Locale(identifier: preferredIdentifier)
    }
    
    // MARK: - Actions -
    @IBAction func moreClicked(_ sender: Any) {
        guard let index = self.indexPath else { return }
        self.delegate?.moreClicked(indexPath: index)
    }
}
