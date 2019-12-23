//
//  ActivityViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 9/10/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

protocol ActivityManagerDelegate {
    func headerClicked(section: Int)
    func addNewActivity(_ activity: ActivityElement)
}

class ActivityViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var searchTextField: DesignableUITextField!
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties -
    private var searchText: String = ""
    private var states: [Bool] = UserInfo.sharedInstance.activityStates
    private var allMyActivity: [ActivityElement] = []
    private var filteredMyActivity: [ActivityElement] = []
    
    private var allFavoriteActivity: [ActivityElement] = []
    private var filteredFavoriteActivity: [ActivityElement] = []
    
    private var allDefaultActivitiys: [ActivityElement] = UserInfo.sharedInstance.getAllActivitys()
    private var filteredDefaultFavorites: [ActivityElement] = UserInfo.sharedInstance.getAllActivitys()
    
    private let ref: DatabaseReference = Database.database().reference()

    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startActivity()
        fetchMyActivitys()
        navigationTitleLabel.text = LS(key: .ACTIVITY_NAVIGATION)
        searchTextField.placeholder = LS(key: .SEARCH)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configurationKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeObserver()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailsActivityViewController, let model = sender as? ActivityElement, (segue.identifier == "sequeActivityDetails") {
            vc.fillScreenByModel(model)
        } else if let vc = segue.destination as? AddActivityViewController {
            vc.fillByDelegate(self)
        }
    }

    // MARK: - Action -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchProduct(_ sender: UITextField) {
        guard let text = sender.text, !text.isEmpty else {
            self.searchText = ""
            filteredMyActivity = allMyActivity
            filteredFavoriteActivity = allFavoriteActivity
            filteredDefaultFavorites = allDefaultActivitiys
            return tableView.reloadData()
        }
        self.searchText = text
        var myActivity: [ActivityElement] = []
        for item in allMyActivity where self.isContains(pattern: text, in: "\(item.name ?? "")") {
            myActivity.append(item)
        }
        filteredMyActivity = myActivity
        
        var favoriteActivity: [ActivityElement] = []
        for item in allFavoriteActivity where self.isContains(pattern: text, in: "\(item.name ?? "")") {
            favoriteActivity.append(item)
        }
        filteredFavoriteActivity = favoriteActivity
        
        var defaultActivity: [ActivityElement] = []
        for item in allDefaultActivitiys where self.isContains(pattern: text, in: "\(item.name ?? "")") {
            defaultActivity.append(item)
        }
        filteredDefaultFavorites = defaultActivity
        tableView.reloadData()
        //
    }
    
    // MARK: - Private -
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        tableView.register(type: SecondRecipeCheckTableVIewCell.self)
        tableView.register(type: FavoritesActivityEmptyCell.self)
        tableView.register(type: ActivityListTableViewCell.self)
        
        tableView.register(type: RecipeCheckTableViewCell.self)
        tableView.register(type: MyActivityEmptyState.self)
        tableView.register(ActivityHeaderTableView.nib, forHeaderFooterViewReuseIdentifier: ActivityHeaderTableView.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    private func startActivity() {
        activity.startAnimating()
        emptyView.isHidden = false
    }
    
    private func stopActivity() {
        activity.stopAnimating()
        emptyView.isHidden = true
    }
    
    private func fetchMyActivitys() {
        FirebaseDBManager.fetchMyActivityInDataBase { [weak self] (list) in
            guard let strongSelf = self else { return }
            strongSelf.allMyActivity.removeAll()
            strongSelf.allFavoriteActivity.removeAll()
            for item in list {
                if item.isFavorite == true {
                    strongSelf.allFavoriteActivity.append(item)
                } else {
                    strongSelf.allMyActivity.append(item)
                }
            }
            strongSelf.filteredMyActivity = strongSelf.allMyActivity
            strongSelf.filteredFavoriteActivity = strongSelf.allFavoriteActivity
            
            strongSelf.setupTableView()
            strongSelf.stopActivity()
        }
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
    
    private func isContains(pattern: String, in text: String?) -> Bool {
        guard let text = text else { return false }
        let lowcasePattern = pattern.lowercased()
        let lowcaseText = text.lowercased()
        
        let fullNameArr = lowcasePattern.split{$0 == " "}.map(String.init)
        var states: [Bool] = []
        for item in fullNameArr {
            states.append(lowcaseText.contains(item))
        }
        return states.contains(true)
    }
    
    private func removeActivity(_ indexPath: IndexPath) {
        let alert = UIAlertController(title: LS(key: .ATTENTION), message: LS(key: .ACTIVITY_REMOVE_ALERT), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: LS(key: .ALERT_YES), style: .default, handler: { [weak self] action in
            guard let strongSelf = self else { return }
            if indexPath.section == 0 && strongSelf.filteredMyActivity.indices.contains(indexPath.row) {
                let activity = strongSelf.filteredMyActivity[indexPath.row]
                strongSelf.filteredMyActivity.remove(at: indexPath.row)
                
                for (index, item) in strongSelf.allMyActivity.enumerated() where item.generalKey == activity.generalKey {
                    strongSelf.allMyActivity.remove(at: index)
                }
                
                guard let uid = Auth.auth().currentUser?.uid, let key = activity.generalKey else { return }
                let ref = Database.database().reference()
                ref.child("USER_LIST").child(uid).child("customActivities").child(key).removeValue()
                
                if strongSelf.filteredMyActivity.isEmpty {
                    strongSelf.tableView.reloadSections(IndexSet(integer: 0), with: .none)
                } else {
                    strongSelf.removeRow(indexPath)
                }
            } else if indexPath.section == 1 && strongSelf.filteredFavoriteActivity.indices.contains(indexPath.row) {
                let activity = strongSelf.filteredFavoriteActivity[indexPath.row]
                strongSelf.filteredFavoriteActivity.remove(at: indexPath.row)
                
                for (index, item) in strongSelf.allFavoriteActivity.enumerated() where item.generalKey == activity.generalKey {
                    strongSelf.allFavoriteActivity.remove(at: index)
                }
                
                guard let uid = Auth.auth().currentUser?.uid, let key = activity.generalKey else { return }
                let ref = Database.database().reference()
                ref.child("USER_LIST").child(uid).child("customActivities").child(key).removeValue()
                
                if strongSelf.filteredFavoriteActivity.isEmpty {
                    strongSelf.tableView.reloadSections(IndexSet(integer: 1), with: .none)
                } else {
                    strongSelf.removeRow(indexPath)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: LS(key: .ALERT_NO), style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    private func deleteActionRow() -> SwipeAction {
        let deleteAction = SwipeAction(style: .destructive, title: nil) { [weak self] action, indexPath in
            guard let strongSelf = self else { return }
            strongSelf.removeActivity(indexPath)
        }
        deleteAction.image = #imageLiteral(resourceName: "Combined Shape (1)")
        deleteAction.hidesWhenSelected = true
        deleteAction.backgroundColor = #colorLiteral(red: 0.9231601357, green: 0.3388705254, blue: 0.3422900438, alpha: 1)
        
        return deleteAction
    }
    
    private func favoriteActionRow() -> SwipeAction {
        let favoriteAction = SwipeAction(style: .destructive, title: nil) { [weak self] action, indexPath in
            guard let strongSelf = self else { return }
            if indexPath.section == 0 && strongSelf.filteredMyActivity.indices.contains(indexPath.row) {
                let selectedActive = strongSelf.filteredMyActivity[indexPath.row]
                var isContains: Bool = false
                for item in strongSelf.filteredFavoriteActivity where item.name == selectedActive.name {
                    isContains = true
                    break
                }
                if isContains {
                    AlertComponent.sharedInctance.showAlertMessage(message: LS(key: .ACTIVITY_DESCRIPTION_1), vc: strongSelf)
                } else {
                    if let uid = Auth.auth().currentUser?.uid {
                        let ref = Database.database().reference()
                        let item = ref.child("USER_LIST").child(uid).child("customActivities").childByAutoId()
                        
                        var someCount = 0
                        if let calories = selectedActive.calories, calories > 0 {
                            someCount = calories
                        }
                        
                        let userData = ["title": selectedActive.name, "time": 30, "calories": someCount, "favorite" : true] as [String : Any]
                        item.setValue(userData)
                        selectedActive.isFavorite = true
                        selectedActive.generalKey = item.key
                        strongSelf.filteredFavoriteActivity.append(selectedActive)
                        strongSelf.allFavoriteActivity.append(selectedActive)
                        strongSelf.tableView.reloadSections(IndexSet(integer: 1), with: .none)
                    }
                    AlertComponent.sharedInctance.showAlertMessage(message: LS(key: .ACTIVITY_DESCRIPTION_2), vc: strongSelf)
                }
            } else if indexPath.section == 2 && strongSelf.filteredDefaultFavorites.indices.contains(indexPath.row) {
                if let uid = Auth.auth().currentUser?.uid {
                    let selectedActive = strongSelf.filteredDefaultFavorites[indexPath.row]
                    var isContains: Bool = false
                    for item in strongSelf.filteredFavoriteActivity where item.name == selectedActive.name {
                        isContains = true
                        break
                    }
                    
                    if isContains {
                        AlertComponent.sharedInctance.showAlertMessage(message: LS(key: .ACTIVITY_DESCRIPTION_1), vc: strongSelf)
                    } else {
                        let ref = Database.database().reference()
                        let item = ref.child("USER_LIST").child(uid).child("customActivities").childByAutoId()
                        let userData = ["title": selectedActive.name, "time": 30, "calories": (selectedActive.count ?? 0) * 30, "favorite" : true] as [String : Any]
                        item.setValue(userData)
                        selectedActive.isFavorite = true
                        selectedActive.generalKey = item.key
                        selectedActive.calories = (selectedActive.count ?? 0) * 30
                        selectedActive.time = 30
                        strongSelf.filteredFavoriteActivity.append(selectedActive)
                        strongSelf.allFavoriteActivity.append(selectedActive)
                        strongSelf.tableView.reloadSections(IndexSet(integer: 1), with: .none)
                        
                        AlertComponent.sharedInctance.showAlertMessage(message: LS(key: .ACTIVITY_DESCRIPTION_2), vc: strongSelf)
                    }
                }
            }
        }
        favoriteAction.image = #imageLiteral(resourceName: "some_4")
        favoriteAction.hidesWhenSelected = true
        favoriteAction.backgroundColor = #colorLiteral(red: 0.977620542, green: 0.6297232509, blue: 0.1792396307, alpha: 1)
        return favoriteAction
    }
}

extension ActivityViewController: UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return states.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if states[section] == false { return 0 }
        switch section {
        case 0:
            return filteredMyActivity.count > 0 ? filteredMyActivity.count : (self.searchText.isEmpty ? 1 : 0)
        case 1:
            return filteredFavoriteActivity.count > 0 ? filteredFavoriteActivity.count : (self.searchText.isEmpty ? 1 : 0)
        case 2:
            return filteredDefaultFavorites.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if filteredMyActivity.isEmpty {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyActivityEmptyState") as? MyActivityEmptyState else { fatalError() }
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityListTableViewCell") as? ActivityListTableViewCell else { fatalError() }
                if filteredMyActivity.indices.contains(indexPath.row) {
                    cell.fillSecondCell(filteredMyActivity[indexPath.row])
                }
                cell.delegate = self
                return cell
            }
        case 1:
            if filteredFavoriteActivity.isEmpty {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesActivityEmptyCell") as? FavoritesActivityEmptyCell else { fatalError() }
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityListTableViewCell") as? ActivityListTableViewCell else { fatalError() }
                if filteredFavoriteActivity.indices.contains(indexPath.row) {
                    cell.fillSecondCell(filteredFavoriteActivity[indexPath.row])
                }
                cell.delegate = self
                return cell
            }
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityListTableViewCell") as? ActivityListTableViewCell else { fatalError() }
            cell.fillCell(filteredDefaultFavorites[indexPath.row])
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedActivity: ActivityElement?
        switch indexPath.section {
        case 0:
            if filteredMyActivity.indices.contains(indexPath.row) {
                selectedActivity = filteredMyActivity[indexPath.row]
            }
        case 1:
            if filteredFavoriteActivity.indices.contains(indexPath.row) {
                selectedActivity = filteredFavoriteActivity[indexPath.row]
            }
        case 2:
            if filteredDefaultFavorites.indices.contains(indexPath.row) {
                selectedActivity = filteredDefaultFavorites[indexPath.row]
            }
        default:
            break
        }
        if let activity = selectedActivity {
            self.performSegue(withIdentifier: "sequeActivityDetails", sender: activity)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ActivityHeaderTableView.reuseIdentifier) as? ActivityHeaderTableView else {
            return nil
        }
        header.contentView.backgroundColor = .white
        
        var state: Bool = true
        switch section {
        case 0:
            state = filteredMyActivity.isEmpty
        case 1:
            state = filteredFavoriteActivity.isEmpty
        case 2:
            state = filteredDefaultFavorites.isEmpty
        default:
            break
        }
        header.fillHeader(section: section, delegate: self, state: self.states[section], state)
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return ActivityHeaderTableView.height
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0000001
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        switch indexPath.section {
        case 0, 1:
            return [deleteActionRow()]
        case 2:
            return [favoriteActionRow()]
        default:
            return []
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.transitionStyle = .drag
        return options
    }
}

extension ActivityViewController: ActivityManagerDelegate {
    
    func addNewActivity(_ activity: ActivityElement) {
        if searchText.isEmpty {
            filteredMyActivity.append(activity)
        } else {
            if self.isContains(pattern: searchText, in: "\(activity.name ?? "")") {
                filteredMyActivity.append(activity)
            }
        }
        allMyActivity.append(activity)
        tableView.reloadSections(IndexSet(integer: 0), with: .none)
    }
    
    func headerClicked(section: Int) {
        self.states[section] = !self.states[section]
        UserInfo.sharedInstance.activityStates[section] = !UserInfo.sharedInstance.activityStates[section]
        UIView.transition(with: tableView,
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.tableView.reloadSectionWithouAnimation(section: section)
        })
    }
}
