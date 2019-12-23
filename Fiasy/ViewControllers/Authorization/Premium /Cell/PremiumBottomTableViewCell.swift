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
    @IBOutlet weak var eazyLabel: UILabel!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var premiumLabel: UILabel!
    @IBOutlet weak var basicLabel: UILabel!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var insertStackView: UIStackView!
    @IBOutlet weak var pageControll: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Properties -
    private var state: PremiumColorState = .black
    private var delegate: PremiumQuizDelegate?
    private let isIphone5 = Display.typeIsLike == .iphone5
    private var slides: [PremiumSecondSlideView] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.text = LS(key: .PREMIUM_TITLE_2)
    }
    
    // MARK: - Life Cicle -
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        pageControll.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
    }
    
    func fillCell(delegate: PremiumQuizDelegate, state: PremiumColorState) {
        self.state = state
        self.delegate = delegate
        
        slides = createSlides()
        fillTextViewDescription()
        setupSlideScrollView(slides: slides)
        
        let mutableAttrString = NSMutableAttributedString()
        mutableAttrString.append(configureAttrString(by: UIFont.sfProTextBold(size: 20),
                                                     color: state == .black ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1), text: LS(key: .LONG_PREM_EASY)))
        mutableAttrString.append(configureAttrString(by: UIFont.sfProTextBold(size: 20),
                                                     color: state == .black ? #colorLiteral(red: 0.8516539931, green: 0.6581981182, blue: 0.267614007, alpha: 1) : #colorLiteral(red: 0.9490196078, green: 0.6013857722, blue: 0.2910895646, alpha: 1), text: " PREMIUM"))
        eazyLabel.attributedText = mutableAttrString
        titleLabel.textColor = state == .black ? #colorLiteral(red: 0.866572082, green: 0.8667211533, blue: 0.8665626645, alpha: 1) : #colorLiteral(red: 0.3450569212, green: 0.3451216519, blue: 0.3450528979, alpha: 1)
        let color = state == .black ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0.2509489655, green: 0.2509984672, blue: 0.2509458363, alpha: 1)
        leftButton.setTitleColor(color, for: .normal)
        rightButton.setTitleColor(color, for: .normal)
        pageControll.pageIndicatorTintColor = state == .black ? #colorLiteral(red: 0.3254516125, green: 0.3254397511, blue: 0.3295465112, alpha: 1) : #colorLiteral(red: 0.8155969381, green: 0.8157377839, blue: 0.815588057, alpha: 1)
        pageControll.currentPageIndicatorTintColor = state == .black ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1): #colorLiteral(red: 0.2587913275, green: 0.2588421106, blue: 0.2587881684, alpha: 1)
        basicLabel.textColor = color
        premiumLabel.textColor = color
        payButton.backgroundColor = state == .black ? #colorLiteral(red: 0.8516539931, green: 0.6581981182, blue: 0.267614007, alpha: 1) : #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)
        payButton.setTitle(LS(key: .CONNECT_PREMIUM).uppercased(), for: .normal)
        
        fillDescription()
    }
    
    func adjustTextViewHeight() {
        descriptionTextView.sizeToFit()
        descriptionTextView.isScrollEnabled = false
    }
    
    // MARK: - Private -
    func setupSlideScrollView(slides: [PremiumSecondSlideView]) {
        scrollView.removeAllSubviews()
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
        insertStackView.removeAllSubviews()
        if insertStackView.subviews.isEmpty {
            for index in 0...6 {
                guard let view = InsertPremiumLockView.fromXib() else { return }
                view.fillView(index: index, state: self.state)
                insertStackView.addArrangedSubview(view)
            }
        }
    }
    
    private func createSlides() -> [PremiumSecondSlideView] {
        var items: [PremiumSecondSlideView] = []
        for index in 0...2 {
            guard let item = PremiumSecondSlideView.fromXib() else { return [] }
            item.fillView(index: index, state: self.state)
            items.append(item)
        }
        return items
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 || scrollView.contentOffset.y < 0 {
            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 0) }
        
        let pageIndex = round(scrollView.contentOffset.x/UIScreen.main.bounds.width)
        pageControll.currentPage = Int(pageIndex)
    }
    
    private func configureAttrString(by font: UIFont, color: UIColor, text: String) -> NSAttributedString {
        return NSAttributedString(string: text, attributes: [.font: font, .foregroundColor: color])
    }
}

extension PremiumBottomTableViewCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        delegate?.showPrivacyScreen()
        return false
    }
}
