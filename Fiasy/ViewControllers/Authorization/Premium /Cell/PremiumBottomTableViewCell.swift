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
            setupSlideScrollView(slides: slides)
            
            pageControll.pageIndicatorTintColor = #colorLiteral(red: 0.8155969381, green: 0.8157377839, blue: 0.815588057, alpha: 1)
            pageControll.currentPageIndicatorTintColor = #colorLiteral(red: 0.2587913275, green: 0.2588421106, blue: 0.2587881684, alpha: 1)
            
            fillDescription()
        }
    }
    
    func fillCell(delegate: PremiumQuizDelegate) {
        self.delegate = delegate
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 || scrollView.contentOffset.y < 0 {
            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 0) }
        
        let pageIndex = round(scrollView.contentOffset.x/UIScreen.main.bounds.width)
        pageControll.currentPage = Int(pageIndex)
    }
}
