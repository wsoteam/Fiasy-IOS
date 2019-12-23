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
    @IBOutlet weak var premiumButton: UIButton!
    @IBOutlet weak var premiumDescriptionLabel: UILabel!
    @IBOutlet weak var expertDescriptionLabel: UILabel!
    @IBOutlet weak var expertNameLabel: UILabel!
    @IBOutlet weak var expertContainerView: UIView!
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
        
        premiumDescriptionLabel.text = LS(key: .ARTICLE_PREMIUM_DESCRIPTION)
        premiumButton.setTitle("          \(LS(key: .ARTICLE_PREMIUM_BUTTON))          ", for: .normal)
    }
    
    // MARK: - Properties -
    private var article: Article?
    private var delegate: ArticlesDetailsDelegate?
    
    // MARK: - Interface -
    func fillRow(article: Article, premState: Bool, delegate: ArticlesDetailsDelegate) {
        self.article = article
        self.delegate = delegate
        
        if let id = article.category?.id {
            if id == 4 {
                expertNameLabel.text = LS(key: .ART_SERIES_AUTHOR_BURLAKOV)
                expertDescriptionLabel.text = LS(key: .ART_SERIES_AUTHOR_BURLAKOV_BIO2)
                expertContainerView.isHidden = false
            } else {
                expertContainerView.isHidden = true
            }
        }
        
        if let path = article.image, let url = try? path.asURL() {
            articleImageView.kf.indicatorType = .activity
            let resource = ImageResource(downloadURL: url)
            articleImageView.kf.setImage(with: resource)
        }
        
        var titleLocalized: String?
        var bodyLocalized: String?
        switch Locale.current.languageCode {
        case "es":
            // испанский
            titleLocalized = article.titleES
            bodyLocalized = article.bodyES
        case "pt":
            // португалия (бразилия)
            titleLocalized = article.titlePT
            bodyLocalized = article.bodyPT
        case "en":
            // английский
            titleLocalized = article.titleENG
            bodyLocalized = article.bodyENG
        case "de":
            // немецикий
            titleLocalized = article.titleDE
            bodyLocalized = article.bodyDE
        default:
            // русский
            titleLocalized = article.titleRU
            bodyLocalized = article.bodyRU
        }
        
        if let title = titleLocalized?.stripOutHtml() {
            let lines = title.split { $0.isNewline }
            let result = lines.joined(separator: "\n")
            articleNameLabel.text = result
        }

        if let text = bodyLocalized {
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
    
    @IBAction func showExpertInfoClicked(_ sender: Any) {
        if let vc = UIApplication.getTopMostViewController() as? ArticlesDetailsViewController {
            vc.performSegue(withIdentifier: "sequeExpertInfo", sender: nil)
        }
    }
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
                    if let des = descrip.withSymbolicTraits(.traitBold) {
                        descrip = des
                    }
                }
                
                if (traits.rawValue & UIFontDescriptor.SymbolicTraits.traitItalic.rawValue) != 0 {
                    if let des = descrip.withSymbolicTraits(.traitItalic) {
                        descrip = des
                    }
                }
                
                attr.addAttribute(.font, value: UIFont(descriptor: descrip, size: fontSize ?? htmlFont.pointSize), range: range)
            }
        }
        self.init(attributedString: attr)
    }
}
