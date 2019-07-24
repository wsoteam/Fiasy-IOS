//
//  DiaryDisplayManager.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 6/7/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import DynamicBlurView

protocol DiaryDisplayManagerDelegate {
    func headerClicked(section: Int)
}

class DiaryDisplayManager: NSObject {
    
    // MARK: - Properties -
    private let tableView: UITableView
    private let delegate: DiaryViewDelegate
    private let emptyBlurView: DynamicBlurView
    private let addProductButton: UIButton
    private var mealTime: [[Mealtime]] = []
    private var removeIndex: IndexPath?
    private var states = Array<Bool>()
    
    // MARK: - Interface -
    init(tableView: UITableView, delegate: DiaryViewDelegate, _ emptyBlurView: DynamicBlurView, _ addProductButton: UIButton) {
        self.emptyBlurView = emptyBlurView
        self.addProductButton = addProductButton
        self.tableView = tableView
        self.delegate = delegate
        super.init()
        setupTableView()
    }
    
    func changeDate(_ mountLabel: UILabel, _ dateLabels: [UILabel], _ selectedDate: Date) {
        mountLabel.text = getMount(date: selectedDate).capitalizeFirst
        for (index, item) in selectedDate.getWeekDates().enumerated() {
            dateLabels[index].text = "\(item.dayNumberOfWeek()!)"
            dateLabels[index].superview?.backgroundColor = item.dayNumberOfWeek()! == selectedDate.dayNumberOfWeek()! ? #colorLiteral(red: 0.2192195952, green: 0.6332430243, blue: 0.5976563096, alpha: 1) : .clear
        }
    }
    
    func sortMealTime(mealTime: [Mealtime]) {
        self.mealTime = UserInfo.sortMealTime(mealtimes: mealTime)
        self.states = [Bool](repeating: false, count: self.mealTime.count)
    }
    
    func removeMealTime() {
        guard let indexPath = self.removeIndex else { return }
        if self.mealTime.indices.contains(indexPath.section) {
            if self.mealTime[indexPath.section].indices.contains(indexPath.row) {
                let mealTime = self.mealTime[indexPath.section][indexPath.row]
                for (index,item) in UserInfo.sharedInstance.allMealtime.enumerated() where item.generalKey == mealTime.generalKey {
                    UserInfo.sharedInstance.allMealtime.remove(at: index)
                }
                
                FirebaseDBManager.removeItem(mealtime: mealTime, handler: {
                    self.mealTime[indexPath.section].remove(at: indexPath.row)
                    if self.mealTime[indexPath.section].isEmpty {
                        self.mealTime.remove(at: indexPath.section)
                    }
                    if self.mealTime.isEmpty {
                        self.emptyBlurView.isHidden = false
                        self.addProductButton.isHidden = false
                    }
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    // MARK: - Private -
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        tableView.register(type: DiaryTableViewCell.self)
        tableView.register(DiaryHeaderView.nib, forHeaderFooterViewReuseIdentifier: DiaryHeaderView.reuseIdentifier)
        tableView.register(DiaryFooterView.nib, forHeaderFooterViewReuseIdentifier: DiaryFooterView.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func getMount(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        return dateFormatter.string(from: date)
    }
}

extension DiaryDisplayManager: UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return mealTime.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !states.isEmpty {
            return states[section] == false ? 0 : mealTime[section].count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryTableViewCell") as? DiaryTableViewCell else { fatalError() }
        if mealTime.indices.contains(indexPath.section) {
            if !states.indices.contains(indexPath.section) {
                self.states = [Bool](repeating: false, count: self.mealTime.count)
            }
            if mealTime[indexPath.section].indices.contains(indexPath.row) {
                cell.fillCell(mealTime: mealTime[indexPath.section][indexPath.row], isContainNext: mealTime[indexPath.section].indices.contains(indexPath.row + 1))
                cell.delegate = self
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return DiaryHeaderView.height
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return DiaryFooterView.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: DiaryHeaderView.reuseIdentifier) as? DiaryHeaderView else {
            return nil
        }
        if mealTime.indices.contains(section) {
            header.fillHeader(mealTimes: mealTime[section], delegate: self, section: section, state: self.states[section])
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: DiaryFooterView.reuseIdentifier) as? DiaryFooterView else {
            return nil
        }
        if mealTime.indices.contains(section) {
            footer.fillFooter(mealTimes: mealTime[section])
        }
        return footer
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let editAction = SwipeAction(style: .destructive, title: nil) { [weak self] action, indexPath in
            guard let `self` = self else { return }
            if self.mealTime.indices.contains(indexPath.section) {
                if self.mealTime[indexPath.section].indices.contains(indexPath.row) {
                        UserInfo.sharedInstance.editMealtime = self.mealTime[indexPath.section][indexPath.row]
                        self.delegate.editMealTime()
                }
            }
        }
    
        editAction.image = #imageLiteral(resourceName: "Flag Icon")
        editAction.hidesWhenSelected = true
        editAction.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        let deleteAction = SwipeAction(style: .destructive, title: nil) { [weak self] action, indexPath in
            self?.removeIndex = indexPath
            self?.delegate.removeMealTime()
        }

        deleteAction.image = #imageLiteral(resourceName: "Group 33")
        deleteAction.hidesWhenSelected = true
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        return [deleteAction, editAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.transitionStyle = .drag
        return options
    }
}

extension DiaryViewController {
    
    func setupTopContainer(date: Date) {
        let day = Calendar(identifier: .iso8601).ordinality(of: .day, in: .month, for: date)!
        let month = Calendar(identifier: .iso8601).ordinality(of: .month, in: .year, for: date)!
        let year = Calendar(identifier: .iso8601).ordinality(of: .year, in: .era, for: date)!

        var calories: Int = 0
        var protein: Int = 0
        var fat: Int = 0
        var carbohydrates: Int = 0

        var isContains: Bool = false
        var mealTime: [Mealtime] = []
        if !UserInfo.sharedInstance.allMealtime.isEmpty {
            for item in UserInfo.sharedInstance.allMealtime where item.day == day && item.month == month && item.year == year {
                
                fat += item.fat ?? 0
                calories += item.calories ?? 0
                protein += item.protein ?? 0
                carbohydrates += item.carbohydrates ?? 0
                isContains = true
                mealTime.append(item)
            }
        }
        self.displayManager.sortMealTime(mealTime: mealTime)
        emptyBlurView.isHidden = isContains
        addProductButton.isHidden = isContains
        
        if let user = UserInfo.sharedInstance.currentUser {
            let currentCalories = ((user.maxKcal ?? 0) - calories)
            fatCountLabel.text = "\(fat) из \(user.maxFat ?? 0) г"
            endedLabel.textColor = (user.maxKcal ?? 0) >= calories ? #colorLiteral(red: 0.1960704327, green: 0.1922241747, blue: 0.1879767179, alpha: 1) : #colorLiteral(red: 0.9624324441, green: 0.3595569134, blue: 0.2823967934, alpha: 1)
            endedLabel.text = (user.maxKcal ?? 0) >= calories ? "осталось" : "сверх нормы"
            caloriesCountLabel.text = (user.maxKcal ?? 0) >= calories ? "\(currentCalories)" : "+\(calories - (user.maxKcal ?? 0))"
            caloriesCountLabel.textColor = (user.maxKcal ?? 0) >= calories ? #colorLiteral(red: 0.1960704327, green: 0.1922241747, blue: 0.1879767179, alpha: 1) : #colorLiteral(red: 0.9624324441, green: 0.3595569134, blue: 0.2823967934, alpha: 1)
            carbohydratesCountLabel.text = "\(carbohydrates) из \(user.maxCarbo ?? 0) г"
            proteinLabel.text = "\(protein) из \(user.maxProt ?? 0) г"
            
            carbohydratesProgress.progress = Float(carbohydrates) / Float(user.maxCarbo ?? 0)
            fatProgress.progress = Float(fat) / Float(user.maxFat ?? 0)
            caloriesProgress.progress = Float(calories) / Float(user.maxKcal ?? 0)
            proteinProgress.progress = Float(protein) / Float(user.maxProt ?? 0)
            
            eatenLabel.text = "\(calories)"
            targetLabel.text = "\((user.maxKcal ?? 0))"
            scorchedLabel.text = ""
        }
        
        activityView.isHidden = true
        self.activity.stopAnimating()
        self.tableView.reloadData()
    }
}

extension DiaryDisplayManager: DiaryDisplayManagerDelegate {
    
    func headerClicked(section: Int) {
        if !states.indices.contains(section) {
            self.states = [Bool](repeating: false, count: self.mealTime.count)
        }
        self.states[section] = !self.states[section]
        UIView.transition(with: tableView,
                    duration: 0.2,
                     options: .transitionCrossDissolve,
                  animations: { self.tableView.reloadData() })
    }
}
