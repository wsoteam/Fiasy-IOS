//
//  PremiumDetailsCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 10/18/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

protocol PremiumDetailsCellDelegate {
    func pay(by index: Int)
}

class PremiumDetailsCell: UITableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var insertStackVIew: UIStackView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    // MARK: - Properties -
    private var delegate: PremiumDetailsDelegate?
    
    // MARK: - Interface -
    func fillCell(delegate: PremiumDetailsDelegate, state: PremiumColorState) {
        self.delegate = delegate

        let mutableAttrString = NSMutableAttributedString()
        mutableAttrString.append(configureAttrString(color: state == .black ? #colorLiteral(red: 0.866572082, green: 0.8667211533, blue: 0.8665626645, alpha: 1) : #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1), text: LS(key: .LONG_PREM_OPEN)))
        mutableAttrString.append(configureAttrString(color: state == .black ? #colorLiteral(red: 0.8516539931, green: 0.6581981182, blue: 0.267614007, alpha: 1) : #colorLiteral(red: 0.9187557101, green: 0.5817510486, blue: 0.2803534865, alpha: 1), text: " PREMIUM"))
        topLabel.attributedText = mutableAttrString
        insertStackVIew.removeAllSubviews()
        for index in 0...2 {
            guard let view = PremiumInsertView.fromXib() else { return }
            view.fillCell(index: index, state: state, delegate: self)
            insertStackVIew.addArrangedSubview(view)
        }
        descriptionTextView.isHidden = false
        fillTextViewDescription()
        adjustTextViewHeight()
    }
    
    // MARK: - Actions -
    //
    
    // MARK: - Private -
    private func adjustTextViewHeight() {
        descriptionTextView.sizeToFit()
        descriptionTextView.isScrollEnabled = false
    }
    
    private func configureAttrString(color: UIColor, text: String) -> NSAttributedString {
        return NSAttributedString(string: text, attributes: [.font: UIFont.sfProTextHeavy(size: 24), .foregroundColor: color])
    }
    
    private func fillTextViewDescription() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.alignment = .center
        let text = NSMutableAttributedString(string: LS(key: .PAY_DESCRIPTION_1))
        text.addAttributes([.font: UIFont.sfProTextRegular(size: 12), .foregroundColor: #colorLiteral(red: 0.6313020587, green: 0.6314132214, blue: 0.6312951446, alpha: 1)], range: NSRange(location: 0, length: text.length))
        
        let interactableText = NSMutableAttributedString(string: LS(key: .PAY_DESCRIPTION_2))
        interactableText.addAttributes([.font: UIFont.sfProTextRegular(size: 12), .foregroundColor: #colorLiteral(red: 0.6313020587, green: 0.6314132214, blue: 0.6312951446, alpha: 1), NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue], range: NSRange(location: 0, length: interactableText.length))
        
        // Adding the link interaction to the interactable text
        interactableText.addAttributes([NSAttributedString.Key.link: "", .foregroundColor: #colorLiteral(red: 0.6313020587, green: 0.6314132214, blue: 0.6312951446, alpha: 1)], range: NSRange(location: 0, length: interactableText.length))
        
        // Adding it all together
        text.append(interactableText)
        
        let end = NSMutableAttributedString(string: " Fiasy")
        end.addAttributes([.font: UIFont.sfProTextRegular(size: 12), .foregroundColor: #colorLiteral(red: 0.6313020587, green: 0.6314132214, blue: 0.6312951446, alpha: 1)], range: NSRange(location: 0, length: end.length))
        text.append(end)
        
        text.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, text.length))
        
        // Set the text view to contain the attributed text
        descriptionTextView.attributedText = text
        descriptionTextView.textAlignment = .center
        descriptionTextView.linkTextAttributes = [.foregroundColor: #colorLiteral(red: 0.6313020587, green: 0.6314132214, blue: 0.6312951446, alpha: 1)]
        
        // Disable editing, but enable selectable so that the link can be selected
        descriptionTextView.isEditable = false
        descriptionTextView.isSelectable = true
        descriptionTextView.delegate = self
    }
    
}

extension PremiumDetailsCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        delegate?.showPrivacyScreen()
        return false
    }
}

extension PremiumDetailsCell: PremiumDetailsCellDelegate {
    func pay(by index: Int) {
        delegate?.showSubscriptions(index)
    }
}
