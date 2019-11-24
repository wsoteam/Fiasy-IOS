//
//  DiaryMeasuringTableViewCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 10/22/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class DiaryMeasuringTableViewCell: UITableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var selectedButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    // MARK: - Properties -
    private var delegate: DiaryDisplayManagerDelegate?
    
    // MARK: - Interface -
    func fillCell(delegate: DiaryDisplayManagerDelegate, selectedDate: Date, allMeasurings: [Measuring]) {
        self.delegate = delegate
        
        var list: [Measuring] = []
        var isContains: Bool = false
        for item in allMeasurings where item.type == .weight {
            isContains = true
            list.append(item)
        }

        weightLabel.text = "\(UserInfo.sharedInstance.currentUser?.weight ?? 0.0) кг".replacingOccurrences(of: ".0", with: "")
        if Calendar.current.component(.day, from: selectedDate) == Calendar.current.component(.day, from: Date()) && Calendar.current.component(.month, from: selectedDate) == Calendar.current.component(.month, from: Date()) && Calendar.current.component(.year, from: selectedDate) == Calendar.current.component(.year, from: Date()) {
            if !isContains {
                descriptionLabel.text = "Вы еще не заносили данные"
                selectedButton.setTitle("Добавить вес", for: .normal)
            } else {
                list = list.sorted (by: {$0.timeInMillis > $1.timeInMillis})
                if let first = list.first, let date = first.date {
                    if let diffInDays = Calendar.current.dateComponents([.day], from: date, to: Date()).day {
                        weightLabel.text = "\(first.weight ?? 0.0)"
                        descriptionLabel.text = "Вы обновляли вес \(diffInDays) \(fetcPrefix(count: diffInDays)) назад"
                        selectedButton.setTitle("Обновить", for: .normal)
                    }
                }
            }
            
            if !allMeasurings.isEmpty {
                for item in allMeasurings where item.type == .weight && (Calendar.current.component(.day, from: selectedDate) == Calendar.current.component(.day, from: item.date ?? Date()) && Calendar.current.component(.month, from: selectedDate) == Calendar.current.component(.month, from: item.date ?? Date()) && Calendar.current.component(.year, from: selectedDate) == Calendar.current.component(.year, from: item.date ?? Date())) {
                    weightLabel.text = "\(item.weight ?? 0.0) кг"
                    descriptionLabel.text = "Вес за сегодня"
                    selectedButton.setTitle("Изменить", for: .normal)
                    break
                }
            }
        } else {
            var contains: Bool = false
            for item in allMeasurings where item.type == .weight && (Calendar.current.component(.day, from: selectedDate) == Calendar.current.component(.day, from: item.date ?? Date()) && Calendar.current.component(.month, from: selectedDate) == Calendar.current.component(.month, from: item.date ?? Date()) && Calendar.current.component(.year, from: selectedDate) == Calendar.current.component(.year, from: item.date ?? Date())) {
                contains = true
                weightLabel.text = "\(item.weight ?? 0.0) кг"
                descriptionLabel.text = "Вес по выбранной дате"
                selectedButton.setTitle("Изменить", for: .normal)
                break
            }
            if !contains {
                weightLabel.text = "\(UserInfo.sharedInstance.currentUser?.weight ?? 0.0) кг".replacingOccurrences(of: ".0", with: "")
                descriptionLabel.text = "Вы еще не заносили данные"
                selectedButton.setTitle("Добавить вес", for: .normal)
            }
        }
    }

    // MARK: - Actions -
    @IBAction func showMeasuringClicked(_ sender: Any) {
        self.delegate?.showMeasuringScreen()
    }
    
    // MARK: - Private -
    private func fetcPrefix(count: Int) -> String {
        switch count {
        case 1:
            return "день"
        case 2,3,4:
            return "дня"
        default:
            return "дней"
        }
    }
}
