//
//  DiaryDisplayManager.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 6/7/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Firebase
import DynamicBlurView

protocol DiaryDisplayManagerDelegate {
    func reloadWaterCell()
    func showWaterDetails()
    func sortMealTime(mealTime: [Mealtime])
    func headerClicked(section: Int)
    func showProductTab()
}

class DiaryDisplayManager: NSObject {
    
    // MARK: - Properties -
    private let tableView: UITableView
    private let topView: UIView
    private let delegate: DiaryViewDelegate
    private var mealTime: [[Mealtime]] = []
    private var removeIndex: IndexPath?
    private var selectedDate: Date = Date()
    private var allActivitySpend: Int = 0
    private var allActivity: [ActivityElement] = []
    private var activitys: [ActivityElement] = []
    private var states: [Bool] = [false, false, false, false, false, false, false]
    private var lastContentOffset: CGFloat = 0
    
    // MARK: - Interface -
    init(_ tableView: UITableView, _ delegate: DiaryViewDelegate, _ topView: UIView) {
        self.topView = topView
        self.tableView = tableView
        self.delegate = delegate
        super.init()
        setupTableView()
    }
    
    func changeDate(_ mountLabel: UILabel, _ selectedDate: Date) {
        mountLabel.text = getMount(date: selectedDate).capitalizeFirst
    }
    
    func reloadContent() {
        self.delegate.stopProgress()
    }
    
    func reloadActivity(_ list: [ActivityElement], selectedDate: Date) {
        self.allActivity = list
        let day = Calendar(identifier: .iso8601).ordinality(of: .day, in: .month, for: selectedDate)!
        let month = Calendar(identifier: .iso8601).ordinality(of: .month, in: .year, for: selectedDate)!
        let year = Calendar(identifier: .iso8601).ordinality(of: .year, in: .era, for: selectedDate)!
        
        var activitys: [ActivityElement] = []
        self.allActivitySpend = 0
        if !list.isEmpty {
            for item in list where item.day == day && item.month == month && item.year == year {
                self.allActivitySpend += item.burned ?? 0
                activitys.append(item)
            }
        }
        self.activitys = activitys
//        self.tableView.reloadSections(IndexSet(integer: 6), with: .none)
        self.delegate.stopProgress()
        self.tableView.reloadData()
    }
    
    func reloadActivityByDate(selectedDate: Date) {
        let day = Calendar(identifier: .iso8601).ordinality(of: .day, in: .month, for: selectedDate)!
        let month = Calendar(identifier: .iso8601).ordinality(of: .month, in: .year, for: selectedDate)!
        let year = Calendar(identifier: .iso8601).ordinality(of: .year, in: .era, for: selectedDate)!
        
        self.allActivitySpend = 0
        var activitys: [ActivityElement] = []
        for item in self.allActivity where item.day == day && item.month == month && item.year == year {
            self.allActivitySpend += item.burned ?? 0
            activitys.append(item)
        }
        self.activitys = activitys
        self.delegate.stopProgress()
        self.tableView.reloadData()
    }
    
    func reloadWater() {
        UIView.performWithoutAnimation {
            tableView.reloadSections(IndexSet(integer: 1), with: .none)
        }
    }
    
    func sortMealTime(mealTime: [Mealtime]) {
        self.mealTime = UserInfo.sortMealTime(mealtimes: mealTime)
        self.delegate.stopProgress()
    }
    
    func removeMealTime() {
        guard let indexPath = self.removeIndex else { return }
        if self.mealTime.indices.contains(indexPath.section - 2) {
            if self.mealTime[indexPath.section - 2].indices.contains(indexPath.row) {
                let mealTime = self.mealTime[indexPath.section - 2][indexPath.row]
                for (index,item) in UserInfo.sharedInstance.allMealtime.enumerated() where item.generalKey == mealTime.generalKey {
                    UserInfo.sharedInstance.allMealtime.remove(at: index)
                }
                
                FirebaseDBManager.removeItem(mealtime: mealTime, handler: {
                    self.mealTime[indexPath.section - 2].remove(at: indexPath.row)
                    if self.mealTime[indexPath.section - 2].isEmpty {
                        //self.mealTime.remove(at: indexPath.section - 1)
                        self.states[indexPath.section] = false
                    }
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    func removeActivity() {
        guard let indexPath = self.removeIndex else { return }
        if self.activitys.indices.contains(indexPath.row) {
            let activity = self.activitys[indexPath.row]
            self.activitys.remove(at: indexPath.row)
            guard let uid = Auth.auth().currentUser?.uid, let key = activity.generalKey else { return }
            for (index,item )in self.allActivity.enumerated() where item.generalKey == key {
                self.allActivity.remove(at: index)
                break
            }
            let ref = Database.database().reference()
            ref.child("USER_LIST").child(uid).child("activities").child(key).removeValue()
            if self.activitys.isEmpty {
                self.tableView.reloadSections(IndexSet(integer: 6), with: .none)
            } else {
                self.removeRow(indexPath)
            }
        }
    }
    
    func changeNewDate(date: Date) {
        
        self.selectedDate = date
        let day = Calendar(identifier: .iso8601).ordinality(of: .day, in: .month, for: selectedDate)!
        let month = Calendar(identifier: .iso8601).ordinality(of: .month, in: .year, for: selectedDate)!
        let year = Calendar(identifier: .iso8601).ordinality(of: .year, in: .era, for: selectedDate)!
        
        var mealTime: [Mealtime] = []
        if !UserInfo.sharedInstance.allMealtime.isEmpty {
            for item in UserInfo.sharedInstance.allMealtime where item.day == day && item.month == month && item.year == year {
                mealTime.append(item)
            }
        }
        self.mealTime = UserInfo.sortMealTime(mealtimes: mealTime)
        reloadActivityByDate(selectedDate: date)
    }
    
    // MARK: - Private -
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        tableView.register(type: DiaryTableViewCell.self)
        tableView.register(type: LimitDiaryTableViewCell.self)
        tableView.register(type: DiaryWaterTableViewCell.self)
        tableView.register(type: ActivityListTableViewCell.self)
        tableView.register(DiaryHeaderView.nib, forHeaderFooterViewReuseIdentifier: DiaryHeaderView.reuseIdentifier)
        tableView.register(DiaryFooterView.nib, forHeaderFooterViewReuseIdentifier: DiaryFooterView.reuseIdentifier)
        tableView.register(DiaryActivityHeaderView.nib, forHeaderFooterViewReuseIdentifier: DiaryActivityHeaderView.reuseIdentifier)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func removeRow(_ indexPath: IndexPath) {
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .left)
            self.tableView.endUpdates()
        })
        CATransaction.commit()
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
        return states.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 { return 1 }
        if !states.isEmpty {
            if states[section] == false {
                return 0
            } else if section == 6 {
                return activitys.count
            } else if mealTime.indices.contains(section - 2) {
                return mealTime[section - 2].count
            } else {
                return 0
            }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LimitDiaryTableViewCell") as? LimitDiaryTableViewCell else { fatalError() }
            cell.fillCell(selectedDate: selectedDate, delegate: self, activityCount: self.allActivitySpend)
            return cell
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryWaterTableViewCell") as? DiaryWaterTableViewCell else { fatalError() }
            cell.fillCell(delegate: self, selectedDate: self.selectedDate)
            return cell
        } else if indexPath.section == 6 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityListTableViewCell") as? ActivityListTableViewCell else { fatalError() }
            if activitys.indices.contains(indexPath.row) {
                cell.fillByDiaryCell(activitys[indexPath.row])
                cell.delegate = self
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryTableViewCell") as? DiaryTableViewCell else { fatalError() }
            if mealTime.indices.contains(indexPath.section - 2) {
                if mealTime[indexPath.section - 2].indices.contains(indexPath.row) {
                    cell.fillCell(mealTime: mealTime[indexPath.section - 2][indexPath.row], isContainNext: mealTime[indexPath.section - 2].indices.contains(indexPath.row + 2))
                    cell.delegate = self
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (section == 0 || section == 1) ? 0.0001 : DiaryHeaderView.height
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        print(section)
        return (section == 5 || section == 6 || section == 0) ? DiaryFooterView.height : 0.0001
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 || section == 1 { return nil }
        
        if section == (states.count - 1) {
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: DiaryActivityHeaderView.reuseIdentifier) as? DiaryActivityHeaderView else {
                return nil
            }
            header.fillHeader(self, section, self.states[section], activitys.isEmpty)
            return header
        } else {
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: DiaryHeaderView.reuseIdentifier) as? DiaryHeaderView else {
                return nil
            }
            
            header.fillHeader(delegate: self, section: section, state: self.states[section], mealTime[section - 2].isEmpty)
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: DiaryFooterView.reuseIdentifier) as? DiaryFooterView, section == 5 || section == 0 || section == 6 else {
            return nil
        }
        return footer
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if indexPath.section == 6 {
            guard orientation == .right else { return nil }
            
            let editAction = SwipeAction(style: .destructive, title: nil) { [weak self] action, indexPath in
                guard let strongSelf = self else { return }
                if let vc = UIApplication.getTopMostViewController() {
                    vc.performSegue(withIdentifier: "sequeActivityEditScreen", sender: strongSelf.activitys[indexPath.row])
                }
            }
            editAction.image = #imageLiteral(resourceName: "Vector (18)")
            editAction.hidesWhenSelected = true
            editAction.backgroundColor = #colorLiteral(red: 0.741094768, green: 0.7412236333, blue: 0.7410866618, alpha: 1)
            
            let deleteAction = SwipeAction(style: .destructive, title: nil) { [weak self] action, indexPath in
                guard let strongSelf = self else { return }
                strongSelf.removeIndex = indexPath
                strongSelf.delegate.removeActivity()
            }
            
            deleteAction.image = #imageLiteral(resourceName: "Combined Shape (1)")
            deleteAction.hidesWhenSelected = true
            deleteAction.backgroundColor = #colorLiteral(red: 0.9231601357, green: 0.3388705254, blue: 0.3422900438, alpha: 1)
            
            return [deleteAction, editAction]
        } else {
            guard orientation == .right, self.mealTime.indices.contains(indexPath.section - 2) else { return nil }
            let isRecipe = self.mealTime[indexPath.section - 2][indexPath.row].isRecipe
            
            if isRecipe == false {
                let editAction = SwipeAction(style: .destructive, title: nil) { [weak self] action, indexPath in
                    guard let `self` = self else { return }
                    if self.mealTime.indices.contains(indexPath.section - 2) {
                        if self.mealTime[indexPath.section - 2].indices.contains(indexPath.row) {
                            UserInfo.sharedInstance.editMealtime = self.mealTime[indexPath.section - 2][indexPath.row]
                            self.delegate.editMealTime()
                        }
                    }
                }
                editAction.image = #imageLiteral(resourceName: "Vector (18)")
                editAction.hidesWhenSelected = true
                editAction.backgroundColor = #colorLiteral(red: 0.741094768, green: 0.7412236333, blue: 0.7410866618, alpha: 1)
                
                let deleteAction = SwipeAction(style: .destructive, title: nil) { [weak self] action, indexPath in
                    self?.removeIndex = indexPath
                    self?.delegate.removeMealTime()
                }
                
                deleteAction.image = #imageLiteral(resourceName: "Combined Shape (1)")
                deleteAction.hidesWhenSelected = true
                deleteAction.backgroundColor = #colorLiteral(red: 0.9231601357, green: 0.3388705254, blue: 0.3422900438, alpha: 1)
                
                return [deleteAction, editAction]
            } else {
                let deleteAction = SwipeAction(style: .destructive, title: nil) { [weak self] action, indexPath in
                    self?.removeIndex = indexPath
                    self?.delegate.removeMealTime()
                }
                deleteAction.image = #imageLiteral(resourceName: "Combined Shape (1)")
                deleteAction.hidesWhenSelected = true
                deleteAction.backgroundColor = #colorLiteral(red: 0.9231601357, green: 0.3388705254, blue: 0.3422900438, alpha: 1)
                
                return [deleteAction]
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.transitionStyle = .drag
        return options
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.lastContentOffset > scrollView.contentOffset.y) {
            UIView.animate(withDuration: 0.5) {
                self.topView.isHidden = false
            }
        } else if (self.lastContentOffset < scrollView.contentOffset.y) {
            UIView.animate(withDuration: 0.5) {
                self.topView.isHidden = true
            }
        }
    }
}

extension UITableView {
    func reloadSectionWithouAnimation(section: Int) {
        UIView.performWithoutAnimation {
            let offset = self.contentOffset
            self.reloadSections(IndexSet(integer: section), with: .none)
            self.contentOffset = offset
        }
    }
}

extension DiaryViewController {
    
    func setupTopContainer(date: Date) {
        self.displayManager.changeNewDate(date: date)
    }
}

extension DiaryDisplayManager: DiaryDisplayManagerDelegate {
    
    func reloadWaterCell() {
        UIView.transition(with: tableView,
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: {
                            UIView.performWithoutAnimation {
                                self.tableView.beginUpdates()
                                self.tableView.endUpdates()
                            }
        })
    }
    
    func showWaterDetails() {
        delegate.showWaterDetails()
    }
    
    func showProductTab() {
        delegate.showProducts()
    }
    
    func headerClicked(section: Int) {
        if section == 6 && self.activitys.isEmpty { return }
        self.states[section] = !self.states[section]
        UIView.transition(with: tableView,
                    duration: 0.2,
                     options: .transitionCrossDissolve,
                  animations: {
                    self.tableView.reloadSectionWithouAnimation(section: section)
        })
    }
}
