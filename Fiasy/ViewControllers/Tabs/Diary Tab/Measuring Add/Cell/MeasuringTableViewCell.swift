//
//  MeasuringTableViewCell.swift
//  Fiasy
//
//  Created by Yuriy Sokirko on 10/22/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import AMPopTip

protocol MeasuringCellDelegate {
    func showDescription()
}

class MeasuringTableViewCell: UITableViewCell {
    
    // MARK: - Outlet's -
    @IBOutlet weak var frameView: UIView!
    @IBOutlet weak var popUpButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Properties -
    private var popTip = PopTip()
    private var delegate: MeasuringDelegate?
    fileprivate var weekViews: [Identifier : MeasuringInsertView] = [:]
    private var lastContentOffset: CGFloat = 0
    private var direction: CVScrollDirection = .none
    private let previous = "Previous"
    private let presented = "Presented"
    private let following = "Following"
    private var currentPage = 1
    private var pageLoadingEnabled = true
    private var pageChanged: Bool {
        return currentPage == 1 ? false : true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        if weekViews.isEmpty {
            initialLoad()
            fillPopTip()
        }
    }
    
    // MARK: - Interface -
    func fillCell(delegate: MeasuringDelegate) {
        self.delegate = delegate
    }
    
    func getView() -> MeasuringInsertView {
        guard let view = MeasuringInsertView.fromXib() else { return MeasuringInsertView() }
        view.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: 50)
        return view
    }

    // MARK: - Private -
    private func initialLoad() {
        scrollView.contentSize = CGSize(width: scrollView.frame.width * 3, height: 50)
        scrollView.layer.masksToBounds = true
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        
        self.insertWeekView(getView(), withIdentifier: self.presented)
    
        if let presented = weekViews[presented] {
            insertWeekView(getView(), withIdentifier: previous)
            insertWeekView(getView(), withIdentifier: following)
        }
        reloadWeekViews()
        
        if let presented = weekViews[presented] {
            scrollView.scrollRectToVisible(presented.frame, animated: false)
        }
    }
    
    private func fillPopTip() {
        popTip.shouldDismissOnTapOutside = true
        popTip.shouldDismissOnSwipeOutside = true
        popTip.shouldDismissOnTap = false
        popTip.bubbleColor = .clear
        popTip.edgeInsets = UIEdgeInsets(top: -10, left: 0, bottom: 0, right: 0)
    }
    
    public func reloadWeekViews() {
        for (identifier, weekView) in weekViews {
            weekView.frame.origin = CGPoint(x: CGFloat(indexOfIdentifier(identifier)) *
                scrollView.frame.width, y: 0)
            weekView.removeFromSuperview()
            scrollView.addSubview(weekView)
        }
    }
    
    private func insertWeekView(_ weekView: MeasuringInsertView, withIdentifier identifier: Identifier) {
        let index = CGFloat(indexOfIdentifier(identifier))
        weekView.frame.origin = CGPoint(x: scrollView.bounds.width * index, y: 0)
        weekViews[identifier] = weekView
        scrollView.addSubview(weekView)
    }
    
    private func indexOfIdentifier(_ identifier: Identifier) -> Int {
        let index: Int
        switch identifier {
            case previous: index = 0
            case presented: index = 1
            case following: index = 2
            default: index = -1
        }
        return index
    }

    func scrolledLeft() {
        if let presentedWeek = weekViews[presented], let followingWeek = weekViews[following] {
            if pageLoadingEnabled {
                pageLoadingEnabled = false
                
                weekViews[previous]?.removeFromSuperview()
                replaceWeekView(presentedWeek, withIdentifier: previous, animatable: false)
                replaceWeekView(followingWeek, withIdentifier: self.presented, animatable: true)
                
                
                insertWeekView(getView(), withIdentifier: following)
//                if let dayViews = followingWeek.dayViews,
//                    let fromDay = dayViews.first,
//                    let toDay = dayViews.last {
//                    self.calendarView.delegate?.didShowNextWeekView?(from: fromDay, to: toDay)
//                }
            }
        }
    }
    
    func replaceWeekView(_ weekView: MeasuringInsertView,
                         withIdentifier identifier: Identifier, animatable: Bool) {
        var weekViewFrame = weekView.frame
        weekViewFrame.origin.x = weekViewFrame.width * CGFloat(indexOfIdentifier(identifier))
        weekView.frame = weekViewFrame
        
        weekViews[identifier] = weekView
        
        if animatable {
            scrollView.scrollRectToVisible(weekViewFrame, animated: false)
        }
    }
    
    func scrolledRight() {
        if let presentedWeek = weekViews[presented], let previousWeek = weekViews[previous] {
            if pageLoadingEnabled {
                pageLoadingEnabled = false

                weekViews[following]?.removeFromSuperview()
                replaceWeekView(presentedWeek, withIdentifier: following, animatable: false)
                replaceWeekView(previousWeek, withIdentifier: presented, animatable: true)

                insertWeekView(getView(), withIdentifier: previous)
//                if let dayViews = previousWeek.dayViews,
//                    let fromDay = dayViews.first,
//                    let toDay = dayViews.last{
//                    self.calendarView.delegate?.didShowPreviousWeekView?(from: fromDay, to: toDay)
//                }
            }
        }
    }
    
    // MARK: - Actions -
    @IBAction func leftClicked(_ sender: Any) {
        pageLoadingEnabled = true
        scrolledLeft()
        if let presented = weekViews[previous] {
            scrollView.scrollRectToVisible(presented.frame, animated: true)
        }
    }
    
    @IBAction func rightClicked(_ sender: Any) {
        pageLoadingEnabled = true
        scrolledRight()
        if let presented = weekViews[following] {
            scrollView.scrollRectToVisible(presented.frame, animated: true)
        }
    }
    
    @IBAction func showPopUpAlertClicked(_ sender: Any) {
        guard let view = MeasuringAlertMiddleWeightView.fromXib() else { return }
        view.frame = CGRect(x: 0, y: 0, width: 200, height: 80)
        view.fillView(delegate: self)
        popTip.show(customView: view, direction: .down, in: contentView, from: frameView.frame)
    }
}

extension MeasuringTableViewCell: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y != 0 {
            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 0)
        }
        
        let page = Int(floor((scrollView.contentOffset.x -
            scrollView.frame.width / 2) / scrollView.frame.width) + 1)
        if currentPage != page { currentPage = page }
        lastContentOffset = scrollView.contentOffset.x
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if pageChanged {
            switch direction {
            case .left: scrolledLeft()
            case .right: scrolledRight()
            default: break
            }
        }
        
        pageLoadingEnabled = true
        direction = .none
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView,
                                  willDecelerate decelerate: Bool) {
        if decelerate {
            let rightBorder = scrollView.frame.width
            if scrollView.contentOffset.x <= rightBorder {
                direction = .right
            } else {
                direction = .left
            }
        }
        
//        for weekView in self.weekViews.values {
//            self.prepareTopMarkersOnWeekView(weekView, hidden: false)
//        }
    }
}

extension MeasuringTableViewCell: MeasuringCellDelegate {
    
    func showDescription() {
        popTip.hide()
        delegate?.showMiddleWeightDescriptionScreen()
    }
}
