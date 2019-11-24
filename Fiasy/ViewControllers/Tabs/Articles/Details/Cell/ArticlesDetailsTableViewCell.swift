//
//  ArticlesDetailsTableViewCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 8/20/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Kingfisher
import VisualEffectView

class ArticlesDetailsTableViewCell: UITableViewCell {
    
    // MARK: - Outlet's -
    @IBOutlet weak var secondPremContainerView: UIView!
    @IBOutlet weak var blurView: VisualEffectView!
    @IBOutlet weak var premiumContainerView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var articleNameLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    
    // MARK: - Life Cicle -
    override func awakeFromNib() {
        super.awakeFromNib()
        
        blurView.colorTint = .clear
        blurView.colorTintAlpha = 0.1
        blurView.blurRadius = 5
        blurView.scale = 1
    }
    
    // MARK: - Properties -
    private var article: Article?
    private var delegate: ArticlesDetailsDelegate?
    
    // MARK: - Interface -
    func fillRow(article: Article, premState: Bool, delegate: ArticlesDetailsDelegate) {
        self.article = article
        self.delegate = delegate
        
        if let path = article.image, let url = try? path.asURL() {
            articleImageView.kf.indicatorType = .activity
            let resource = ImageResource(downloadURL: url)
            articleImageView.kf.setImage(with: resource)
        }
        articleNameLabel.text = article.titleRU?.stripOutHtml()
        if let text = article.bodyRU {
            let attr = try? NSAttributedString(htmlString: text, font: UIFont.sfProTextMedium(size: 15))
            messageLabel.attributedText = attr
        }
        if article.premium {
            if premState {
                premiumContainerView.isHidden = true
                secondPremContainerView.isHidden = true
            } else {
                premiumContainerView.isHidden = false
                secondPremContainerView.isHidden = false
            }
        } else {
            premiumContainerView.isHidden = true
            secondPremContainerView.isHidden = true
        }
    }
    
    // MARK: - Actions -
    @IBAction func showPremiumScreen(_ sender: Any) {
        self.delegate?.showPremiumScreen()
    }
    
    
    
    // MARK: - Private -
//    private func stringFromHtml(string: String) -> NSAttributedString? {
//        do {
//            let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
//            if let d = data {
//                let str = try NSAttributedString(data: d,
//                                                 options: [NSAttributedString.DocumentReadingOptionKey: NSHTMLTextDocumentType],
//                                                 documentAttributes: nil)
//                return str
//            }
//        } catch {
//        }
//        return nil
//    }
}

extension NSAttributedString {
    
    convenience init(htmlString html: String, font: UIFont? = nil, useDocumentFontSize: Bool = false) throws {
        let options: [NSAttributedString.DocumentReadingOptionKey : Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        let data = html.data(using: .utf8, allowLossyConversion: true)
        guard (data != nil), let fontFamily = font?.familyName, let attr = try? NSMutableAttributedString(data: data!, options: options, documentAttributes: nil) else {
            try self.init(data: data ?? Data(html.utf8), options: options, documentAttributes: nil)
            return
        }
        
        let fontSize: CGFloat? = useDocumentFontSize ? nil : font!.pointSize
        let range = NSRange(location: 0, length: attr.length)
        attr.enumerateAttribute(.font, in: range, options: .longestEffectiveRangeNotRequired) { attrib, range, _ in
            if let htmlFont = attrib as? UIFont {
                let traits = htmlFont.fontDescriptor.symbolicTraits
                var descrip = htmlFont.fontDescriptor.withFamily(fontFamily)
                
                if (traits.rawValue & UIFontDescriptor.SymbolicTraits.traitBold.rawValue) != 0 {
                    descrip = descrip.withSymbolicTraits(.traitBold)!
                }
                
                if (traits.rawValue & UIFontDescriptor.SymbolicTraits.traitItalic.rawValue) != 0 {
                    descrip = descrip.withSymbolicTraits(.traitItalic)!
                }
                
                attr.addAttribute(.font, value: UIFont(descriptor: descrip, size: fontSize ?? htmlFont.pointSize), range: range)
            }
        }
        self.init(attributedString: attr)
    }
}
