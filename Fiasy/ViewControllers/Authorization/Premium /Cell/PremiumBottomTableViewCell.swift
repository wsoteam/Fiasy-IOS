//
//  PremiumBottomTableViewCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 10/17/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class PremiumBottomTableViewCell: UITableViewCell, UIScrollViewDelegate {

    // MARK: - Outlet -
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var insertStackView: UIStackView!
    @IBOutlet weak var pageControll: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Properties -
    private var delegate: PremiumQuizDelegate?
    private let isIphone5 = Display.typeIsLike == .iphone5
    private var slides: [PremiumSecondSlideView] = []
    
    // MARK: - Life Cicle -
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        pageControll.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        
        if slides.isEmpty {
            slides = createSlides()
            fillTextViewDescription()
            setupSlideScrollView(slides: slides)
            
            pageControll.pageIndicatorTintColor = #colorLiteral(red: 0.8155969381, green: 0.8157377839, blue: 0.815588057, alpha: 1)
            pageControll.currentPageIndicatorTintColor = #colorLiteral(red: 0.2587913275, green: 0.2588421106, blue: 0.2587881684, alpha: 1)
            
            fillDescription()
        }
    }
    
    func fillCell(delegate: PremiumQuizDelegate) {
        self.delegate = delegate
    }
    
    func adjustTextViewHeight() {
        descriptionTextView.sizeToFit()
        descriptionTextView.isScrollEnabled = false
    }
    
    // MARK: - Private -
    func setupSlideScrollView(slides: [PremiumSecondSlideView]) {
        scrollView.layoutIfNeeded()
        scrollView.contentSize = CGSize(width: (UIScreen.main.bounds.width - 40) * CGFloat(slides.count), height: 195)
        for (index, item) in slides.enumerated() {
            item.frame = CGRect(x: ((UIScreen.main.bounds.width - 40) * CGFloat(index)), y: 0, width: (UIScreen.main.bounds.width - 40), height: 195)
            scrollView.addSubview(item)
        }
    }
    
    // MARK: - Actions -
    @IBAction func payClicked(_ sender: Any) {
        guard let delegate = self.delegate else { return }
        delegate.showPremiumList()
    }
    
    // MARK: - Private -
    private func fillDescription() {
        if insertStackView.subviews.isEmpty {
            for index in 0...6 {
                guard let view = InsertPremiumLockView.fromXib() else { return }
                view.fillView(index: index)
                insertStackView.addArrangedSubview(view)
            }
        }
    }
    
    private func createSlides() -> [PremiumSecondSlideView] {
        var items: [PremiumSecondSlideView] = []
        for index in 0...2 {
            guard let item = PremiumSecondSlideView.fromXib() else { return [] }
            item.fillView(index: index)
            items.append(item)
        }
        return items
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 || scrollView.contentOffset.y < 0 {
            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 0) }
        
        let pageIndex = round(scrollView.contentOffset.x/UIScreen.main.bounds.width)
        pageControll.currentPage = Int(pageIndex)
    }
}

extension PremiumBottomTableViewCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        delegate?.showPrivacyScreen()
        return false
    }
}
