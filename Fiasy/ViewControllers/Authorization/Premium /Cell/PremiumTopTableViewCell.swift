//
//  PremiumTopTableViewCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 10/17/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class PremiumTopTableViewCell: UITableViewCell, UIScrollViewDelegate {
    
    // MARK: - Outlet -
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Properties -
    private let isIphone5 = Display.typeIsLike == .iphone5
    private var slides: [PremiumSlideView] = []
    private var delegate: PremiumQuizDelegate?
    
    // MARK: - Life Cicle -
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if slides.isEmpty {
            slides = createSlides()
            setupSlideScrollView(slides: slides)
        }
    }
    
    // MARK: - Interface -
    func fillCell(delegate: PremiumQuizDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Actions -
    @IBAction func payClicked(_ sender: Any) {
        delegate?.purchedClicked()
    }

    // MARK: - Private -
    func setupSlideScrollView(slides: [PremiumSlideView]) {
        scrollView.layoutIfNeeded()
        scrollView.contentSize = CGSize(width: (UIScreen.main.bounds.width - 40) * CGFloat(slides.count), height: 181)
        for (index, item) in slides.enumerated() {
            item.frame = CGRect(x: ((UIScreen.main.bounds.width - 40) * CGFloat(index)), y: 0, width: (UIScreen.main.bounds.width - 40), height: 181)
            scrollView.addSubview(item)
        }
    }
    
    private func createSlides() -> [PremiumSlideView] {
        var items: [PremiumSlideView] = []
        for index in 0...2 {
            guard let item = PremiumSlideView.fromXib() else { return [] }
            item.fillCell(index: index)
            items.append(item)
        }
        return items
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 || scrollView.contentOffset.y < 0 {
            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 0) }
        
        let pageIndex = round(scrollView.contentOffset.x/UIScreen.main.bounds.width)
        delegate?.changeSubscriptionIndex(index: Int(pageIndex))
    }
}
