//
//  PremiumDetailsCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 10/18/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class PremiumDetailsCell: UITableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var bottomImageView: UIImageView!
    @IBOutlet weak var topImageView: UIImageView!
    
    // MARK: - Properties -
    private var indexCell: Int?
    private var delegate: PremiumDetailsDelegate?
    
    // MARK: - Interface -
    func fillCell(index: Int, delegate: PremiumDetailsDelegate) {
        self.indexCell = index
        self.delegate = delegate
        
        switch index {
        case 0:
            descriptionTextView.isHidden = true
            topImageView.isHidden = false
            bottomImageView.image = #imageLiteral(resourceName: "price1")
        case 1:
            descriptionTextView.isHidden = true
            topImageView.isHidden = true
            bottomImageView.image = #imageLiteral(resourceName: "price2")
        case 2:
            descriptionTextView.isHidden = false
            topImageView.isHidden = true
            bottomImageView.image = #imageLiteral(resourceName: "price3")
            fillTextViewDescription()
            adjustTextViewHeight()
        default:
            break
        }
    }
    
    // MARK: - Actions -
    @IBAction func payClicked(_ sender: Any) {
        guard let selectedIndex = indexCell else { return }
        delegate?.showSubscriptions(selectedIndex)
    }
    
    // MARK: - Private -
    private func adjustTextViewHeight() {
        descriptionTextView.sizeToFit()
        descriptionTextView.isScrollEnabled = false
    }
    
    private func fillTextViewDescription() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.alignment = .center
        let text = NSMutableAttributedString(string: "Покупая Fiasy PRO, вы получаете доступ ко всем премиум-функциям. Стоимость PRO-подписки снимается с вашего аккаунта iTunes. Вы сможете управлять своей PRO-подпиской или отменить ее в любой момент через настройки своего аккаунта iTunes. Подписка PRO автоматически продлевается, если она не была не отменена, как минимум, за 24 часа до момента ее истечения, стоимость подписки при этом остается прежней. В момент покупки или продления на вашем аккаунте должно быть достаточно средств. Вы можете оплатить подписку с помощью подарочных карт App Store. При покупке подписки любая неиспользованная часть подписки или периода бесплатного использования будет аннулирована. Подписываясь на PRO, вы принимаете условия использования App Store и ")
        text.addAttributes([.font: UIFont.sfProTextRegular(size: 12), .foregroundColor: #colorLiteral(red: 0.6313020587, green: 0.6314132214, blue: 0.6312951446, alpha: 1)], range: NSRange(location: 0, length: text.length))
        
        let interactableText = NSMutableAttributedString(string: "условия использования и политику конфиденциальности")
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
