//
//  MeasuringInsertView.swift
//  Fiasy
//
//  Created by Yuriy Sokirko on 10/22/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class MeasuringInsertView: UIView {
    
    // MARK: - Outlet's -
    @IBOutlet var weekNumberButtons: [UIButton]!
    @IBOutlet var weekNumberLabels: [UILabel]!
    @IBOutlet weak var backgroundView: UIView!
    
    // MARK: - Properties -
    private var delegate: MeasuringCellDelegate?
    private var measurings: [Measuring] = []
    private var sortedArray: [Measuring?] = [nil, nil, nil, nil, nil, nil, nil]
    private var filledDate: Date = Date()
    
    // MARK: - Interface -
    func fillView(_ date: Date, _ measurings: [Measuring], _ delegate: MeasuringCellDelegate?) {
        self.measurings.removeAll()
        self.delegate = delegate

        self.filledDate = date

        for item in measurings where item.type == .weight {
            self.measurings.append(item)
        }
        if !measurings.isEmpty {
            for (index, item) in date.getWeekDates().enumerated() {
                var findMeasurings: Measuring?
                for secondItem in measurings where secondItem.type == .weight && (Calendar.current.component(.day, from: secondItem.date ?? Date()) == Calendar.current.component(.day, from: item) && Calendar.current.component(.month, from: secondItem.date ?? Date()) == Calendar.current.component(.month, from: item) && Calendar.current.component(.year, from: secondItem.date ?? Date()) == Calendar.current.component(.year, from: item)) {
                    findMeasurings = secondItem
                    break
                }
                if let find = findMeasurings {
                    sortedArray[index] = find
                    weekNumberButtons[index].setImage(UIImage(), for: .normal)
                    weekNumberLabels[index].text = "\(find.weight ?? 0.0)"
                } else {
                    sortedArray[index] = nil
                    let color = Date().millisecondsSince1970 < item.millisecondsSince1970 ? #colorLiteral(red: 0.7685428858, green: 0.7686761618, blue: 0.7685345411, alpha: 1) : #colorLiteral(red: 0.9344636798, green: 0.5902308822, blue: 0.1663158238, alpha: 1)
                    weekNumberButtons[index].tintColor = color
                    weekNumberButtons[index].setImage(#imageLiteral(resourceName: "plus_icon"), for: .normal)
                    weekNumberLabels[index].text = ""
                }
            }
        } else {
            for item in weekNumberLabels {
                item.text = ""
            }
            for item in weekNumberButtons {
                item.setImage(UIImage(), for: .normal)
            }
        }
    }
    
    func reuseView() {
        for item in weekNumberLabels {
            item.text = ""
        }
        for item in weekNumberButtons {
            item.setImage(UIImage(), for: .normal)
        }
    }
    
    func reloadView(_ date: Date, _ measurings: [Measuring]) {
        self.measurings.removeAll()
        self.filledDate = date
        
        for item in measurings where item.type == .weight {
            self.measurings.append(item)
        }
        
        if !measurings.isEmpty {
            for (index, item) in date.getWeekDates().enumerated() {
                var findMeasurings: Measuring?
                for secondItem in measurings where secondItem.type == .weight && (Calendar.current.component(.day, from: secondItem.date ?? Date()) == Calendar.current.component(.day, from: item) && Calendar.current.component(.month, from: secondItem.date ?? Date()) == Calendar.current.component(.month, from: item) && Calendar.current.component(.year, from: secondItem.date ?? Date()) == Calendar.current.component(.year, from: item)) {
                    findMeasurings = secondItem
                    break
                }
                if let find = findMeasurings {
                    sortedArray[index] = find
                    weekNumberButtons[index].setImage(UIImage(), for: .normal)
                    weekNumberLabels[index].text = "\(find.weight ?? 0.0)"
                } else {
                    sortedArray[index] = nil
                    let color = Date().millisecondsSince1970 < item.millisecondsSince1970 ? #colorLiteral(red: 0.7685428858, green: 0.7686761618, blue: 0.7685345411, alpha: 1) : #colorLiteral(red: 0.9344636798, green: 0.5902308822, blue: 0.1663158238, alpha: 1)
                    weekNumberButtons[index].tintColor = color
                    weekNumberButtons[index].setImage(#imageLiteral(resourceName: "plus_icon"), for: .normal)
                    weekNumberLabels[index].text = ""
                }
            }
        } else {
            for item in weekNumberLabels {
                item.text = ""
            }
            for item in weekNumberButtons {
                item.setImage(UIImage(), for: .normal)
            }
        }
    }
    
    // MARK: - Actions -
    @IBAction func addNewMeasuringClicked(_ sender: UIButton) {
        let selectedDate = filledDate.getWeekDates()[sender.tag]
        if Date().millisecondsSince1970 < selectedDate.millisecondsSince1970 {
            delegate?.showAlert(button: sender)
        } else {
            delegate?.addNewMeasuring(date: filledDate.getWeekDates()[sender.tag], measuring: sortedArray[sender.tag])
        }
    }    
}
