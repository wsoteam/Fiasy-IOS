//
//  SearchSuggestProductCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 11/6/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class SearchSuggestProductCell: UITableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var topSeparatorView: UIView!
    @IBOutlet weak var titleButton: UIButton!
    
    // MARK: - Life Cicle -
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleButton.titleLabel?.numberOfLines = 0
        titleButton.titleLabel?.lineBreakMode = .byWordWrapping
    }
    
    // MARK: - Interface -
    func fillCell(product: ProductInfo, searchText: String, indexPath: IndexPath) {
        topSeparatorView.isHidden = indexPath.row != 0
        if let name = product.name {
            var lastName: String = ""
            let fullNameLastArr = searchText.split{$0 == " "}.map(String.init)
            for item in fullNameLastArr where !item.isEmpty {
                lastName = lastName.isEmpty ? item : lastName + " \(item)"
            }
            let secondFullNameLastArr = lastName.split{$0 == " "}.map(String.init)
            titleButton.setAttributedTitle(generateAttributedString(with: searchText, targetString: name, list: secondFullNameLastArr), for: .normal)
        }
    }
    
    // MARK: - Private -
    private func generateAttributedString(with searchTerm: String, targetString: String, list: [String]) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: targetString, attributes: [NSAttributedString.Key.font: UIFont.sfProTextSemibold(size: 17), NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)])
        
        if list.count > 1 {
            do {
                for text in list {
                    let regex = try NSRegularExpression(pattern: text, options: .caseInsensitive)
                    let range = NSRange(location: 0, length: targetString.utf16.count)
                    if let first = regex.matches(in: targetString, options: .withTransparentBounds, range: range).first {
                        attributedString.addAttributes([NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)], range: first.range)
                    }
//                    for match in regex.matches(in: targetString, options: .withTransparentBounds, range: range) {
//                        attributedString.addAttributes([NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)], range: match.range)
//                    }
                }
                return attributedString
            } catch _ {
                NSLog("Error creating regular expresion")
                return attributedString
            }
        } else {
            guard let first = list.first else { return attributedString }
            do {
//                let regex = try NSRegularExpression(pattern: searchTerm.trimmingCharacters(in: .whitespacesAndNewlines).folding(options: .diacriticInsensitive, locale: .current), options: .caseInsensitive)
                let regex = try NSRegularExpression(pattern: first, options: .caseInsensitive)
                let range = NSRange(location: 0, length: targetString.utf16.count)
//                for match in regex.matches(in: targetString, options: .withTransparentBounds, range: range) {
//                    attributedString.addAttributes([NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)], range: match.range)
//                }
                if let first = regex.matches(in: targetString, options: .withTransparentBounds, range: range).first {
                    attributedString.addAttributes([NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)], range: first.range)
                }
                return attributedString
            } catch _ {
                NSLog("Error creating regular expresion")
                return attributedString
            }
        }
    }
}
