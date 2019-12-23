//
//  MeasuringTableViewCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 10/22/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import AMPopTip

protocol MeasuringCellDelegate {
    func showAlert(button: UIButton)
    func addNewMeasuring(date: Date, measuring: Measuring?)
    func showDescription()
}

class MeasuringTableViewCell: UITableViewCell {
    
    // MARK: - Outlet's -
    @IBOutlet weak var middleWeightLabel: UILabel!
    @IBOutlet weak var averageWeightLabel: UILabel!
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var frameView: UIView!
    @IBOutlet weak var popUpButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Properties -
    private var popTip = PopTip()
    private var secondPopTip = PopTip()
    private var selectedData = Date()
    private var delegate: MeasuringDelegate?
    private var currentYear = Calendar.current.component(.year, from: Date())
    private var currentMonth = Calendar.current.component(.month, from: Date())
    private var currentDay = Calendar.current.component(.day, from: Date())
    private var allMeasurings: [Measuring] = []
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
    private lazy var weekFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone(name: "GMT")! as TimeZone
        formatter.dateFormat = "dd.MM"
        return formatter
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()

        if weekViews.isEmpty {
            scrollView.layoutIfNeeded()
            initialLoad()
            fillPopTip()
            leftButton.imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        middleWeightLabel.text = LS(key: .MEASURING_TITLE4)
    }
    
    // MARK: - Interface -
    func fillCell(delegate: MeasuringDelegate, allMeasurings: [Measuring]) {
        self.delegate = delegate
        self.allMeasurings = allMeasurings
    }
    
    func updatePresent(allMeasurings: [Measuring]) {
        self.allMeasurings = allMeasurings
        if let view = weekViews[presented] {
            view.reloadView(selectedData, allMeasurings)
        }
        applySelectedDate()
    }

    func getView(withIdentifier: Identifier) -> MeasuringInsertView {
        guard let view = MeasuringInsertView.fromXib() else { return MeasuringInsertView() }
        view.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: 50)
         
        if let previous = selectedData.getPreviousWeek(), withIdentifier == self.previous {
            view.fillView(previous, allMeasurings, self)
        } else if let next = selectedData.getNextWeek(), withIdentifier == self.following {
            view.fillView(next, allMeasurings, self)
        } else {
            view.fillView(selectedData, allMeasurings, self)
        }
        return view
    }

    // MARK: - Private -
    private func initialLoad() {
        scrollView.contentSize = CGSize(width: scrollView.frame.width * 3, height: 50)
        scrollView.layer.masksToBounds = true
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        
        applySelectedDate()
        self.insertWeekView(getView(withIdentifier: self.presented), withIdentifier: self.presented)
    
        if let _ = weekViews[presented] {
            insertWeekView(getView(withIdentifier: previous), withIdentifier: previous)
            insertWeekView(getView(withIdentifier: following), withIdentifier: following)
        }
        reloadWeekViews()
        
        if let presented = weekViews[presented] {
            scrollView.scrollRectToVisible(presented.frame, animated: false)
        }
    }
    
    private func applySelectedDate() {
        yearLabel.text = "\(Calendar.current.component(.year, from: selectedData))"
        weekLabel.text = "\(weekFormatter.string(from: selectedData.startOfWeek)) - \(weekFormatter.string(from: selectedData.endOfWeek!))"
        
        var average: Double = 0.0
        var count: Int = 0
        for item in self.allMeasurings {
            var findMeasurings: Measuring?
            for secondItem in self.selectedData.getWeekDates() where item.type == .weight && (Calendar.current.component(.day, from: item.date ?? Date()) == Calendar.current.component(.day, from: secondItem) && Calendar.current.component(.month, from: item.date ?? Date()) == Calendar.current.component(.month, from: secondItem) && Calendar.current.component(.year, from: item.date ?? Date()) == Calendar.current.component(.year, from: secondItem)) {
                findMeasurings = item
                break
            }
            if let items = findMeasurings {
                average += items.weight ?? 0.0
                count += 1
            }
        }
        
        if average > 0.0 {
            averageWeightLabel.text = "\((average/Double(count)).rounded(toPlaces: 1)) \(LS(key: .WEIGHT_UNIT))"
        } else {
            averageWeightLabel.text = "--"
        }
    }
    
    private func fillPopTip() {
        popTip.shouldDismissOnTapOutside = true
        popTip.shouldDismissOnSwipeOutside = true
        popTip.shouldDismissOnTap = false
        popTip.bubbleColor = .clear
        popTip.edgeInsets = UIEdgeInsets(top: -10, left: 0, bottom: 0, right: 0)
        
        secondPopTip.shouldDismissOnTapOutside = true
        secondPopTip.shouldDismissOnSwipeOutside = true
        secondPopTip.shouldDismissOnTap = true
        secondPopTip.bubbleColor = .clear
        secondPopTip.edgeInsets = UIEdgeInsets(top: 80, left: -10, bottom: 0, right: -10)
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
    
    func replaceWeekView(_ weekView: MeasuringInsertView,
                         withIdentifier identifier: Identifier, animatable: Bool) {
        var weekViewFrame = weekView.frame
        weekViewFrame.origin.x = weekViewFrame.width * CGFloat(indexOfIdentifier(identifier))
        weekView.frame = weekViewFrame
        
        if let previous = selectedData.getPreviousWeek(), identifier == self.previous {
            weekView.fillView(previous, allMeasurings, self)
        } else if let next = selectedData.getNextWeek(), identifier == self.following {
            weekView.fillView(next, allMeasurings, self)
        } else {
            weekView.fillView(selectedData, allMeasurings, self)
        }
        weekViews[identifier] = weekView
        
        if animatable {
            scrollView.scrollRectToVisible(weekViewFrame, animated: false)
        }
    }

    func scrolledLeft() {
        if let presentedWeek = weekViews[presented], let previous = weekViews[previous] {
            if pageLoadingEnabled {
                pageLoadingEnabled = false
                
                if let previous = selectedData.getPreviousWeek() {
                    selectedData = previous
                    applySelectedDate()
                }

                weekViews[following]?.removeFromSuperview()
                replaceWeekView(presentedWeek, withIdentifier: following, animatable: false)
                replaceWeekView(previous, withIdentifier: self.presented, animatable: true)
                insertWeekView(getView(withIdentifier: self.previous), withIdentifier: self.previous)
            }
        }
    }
    
    func scrolledRight() {
        if let presentedWeek = weekViews[presented], let following = weekViews[following] {
            if pageLoadingEnabled {
                pageLoadingEnabled = false
                
                if let next = selectedData.getNextWeek() {
                    selectedData = next
                    applySelectedDate()
                }

                weekViews[previous]?.removeFromSuperview()
                replaceWeekView(presentedWeek, withIdentifier: previous, animatable: false)
                replaceWeekView(following, withIdentifier: presented, animatable: true)

                insertWeekView(getView(withIdentifier: self.following), withIdentifier: self.following)
            }
        }
    }
    
    // MARK: - Actions -
    @IBAction func leftClicked(_ sender: Any) {
        pageLoadingEnabled = true
        scrolledLeft()
    }
    
    @IBAction func rightClicked(_ sender: Any) {
        pageLoadingEnabled = true
        scrolledRight()
    }
    
    @IBAction func showPopUpAlertClicked(_ sender: Any) {
        guard let view = MeasuringAlertMiddleWeightView.fromXib(), !popTip.isVisible else { return }
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
                direction = .left
            } else {
                direction = .right
            }
        }
    }
}

extension MeasuringTableViewCell: MeasuringCellDelegate {
    
    func showAlert(button: UIButton) {
        guard let view = MeasuringSecondAlertView.fromXib() else { return }
        view.frame = CGRect(x: 0, y: 0, width: 150, height: 60)
        view.fillView(tag: button.tag)
        secondPopTip.show(customView: view, direction: .none, in: contentView, from: button.superview!.frame)
    }
    
    func addNewMeasuring(date: Date, measuring: Measuring?) {
        delegate?.showPicker(date: date, measuring: measuring)
    }
    
    func showDescription() {
        popTip.hide()
        delegate?.showMiddleWeightDescriptionScreen()
    }
}
