//
//  NutritionPlanViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 1/20/20.
//  Copyright © 2020 Eugen Lipatov. All rights reserved.
//

import UIKit
import SwiftEntryKit

protocol NutritionPlanDelegate {
    func removeLike(nutrition: NutritionDetail?, _ button: UIButton)
    func fillLike(key: String, nutrition: NutritionDetail)
}

class NutritionPlanViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var blockedView: UIView!
    @IBOutlet weak var emptySearchView: UIView!
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    @IBOutlet weak var generalStackView: UIStackView!
    @IBOutlet weak var cancelSearchButton: UIButton!
    @IBOutlet weak var textField: DesignableUITextField!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationContainerView: UIView!
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Properties -
    private var activeButton = UIButton()
    private var list: [Nutrition] = []
    private var filteredList: [Nutrition] = []
    private var likedList: [String] = []
    private var recipes: [[SecondRecipe]] = [[]]
    private var likedNutrition: [NutritionDetail] = []
    private var screenState: RecipesViewState = .list
    private let isIphone5 = Display.typeIsLike == .iphone5
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    lazy var removeAlertPresetsView: TemplateAlertPresetsView = {
        guard let view = TemplateAlertPresetsView.fromXib() else { return TemplateAlertPresetsView() }
        view.removeButton.setTitle(" Статья удалена из списка", for: .normal)
        return view
    }()
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FirebaseDBManager.fetchSecondNewRecipesInDataBase { [weak self] (recipes)  in
            guard let strongSelf = self else { return }
            strongSelf.recipes = recipes
        }
        
        showActivity()
        screenState = .list
        textField.placeholder = "Поиск по статьям"
        FirebaseDBManager.fetchLikeNutritionInDataBase { [weak self] (list) in
            guard let strongSelf = self else { return }
            for item in list {
                if let name = item.name {
                    strongSelf.likedList.append(name)
                }
            }
            strongSelf.likedNutrition = list
            FirebaseDBManager.fetchNutritionsInDataBase { (list) in
                strongSelf.list = list
                for (firstIndex, item) in list.enumerated() {
                    for (secondIndex, secondItem) in item.list.enumerated() where strongSelf.likedList.contains(secondItem.name ?? "") {
                        strongSelf.list[firstIndex].list[secondIndex].isLiked = true
                    }
                }

                strongSelf.filteredList = strongSelf.list
                strongSelf.setupTableView()
                strongSelf.hideActivity()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configurationKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeObserver()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0,y: 0,width: 0, height: CGFloat.leastNormalMagnitude))
        
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        tableView.contentInsetAdjustmentBehavior = .never
        edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
    }
    
    func removeLikeByPrevious(nutrition: NutritionDetail?) {
        for (index, item) in filteredList.enumerated() {
            for (secondIndex, secondItem) in item.list.enumerated() where secondItem.name == nutrition?.name {
                self.filteredList[index].list[secondIndex].isLiked = false
                for (index, item) in self.likedNutrition.enumerated() where item.name == nutrition?.name {
                    self.likedNutrition.remove(at: index)
                    break
                }
                tableView.reloadData()
                break
            }
        }
    }
    
    func isEmptyRecipes() -> Bool {
        return recipes.isEmpty
    }
    
    // MARK: - Privates -
    private func removeRow(_ indexPath: IndexPath) {
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .left)
            self.tableView.endUpdates()
        })
        CATransaction.commit()
    }
    
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        tableView.register(type: NutritionPlanListRowCell.self)
        tableView.register(RecipesHeaderView.nib, forHeaderFooterViewReuseIdentifier: RecipesHeaderView.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func showActivity() {
        progressView.isHidden = false
        activity.startAnimating()
    }
    
    private func hideActivity() {
        progressView.isHidden = true
        activity.stopAnimating()
    }
    
    private func addShadow(_ view: UIView) {
        UIView.animate(withDuration: 0.1) { 
            view.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.5030455508).cgColor
        }
    }
    
    private func deleteShadow(_ view: UIView) {
        UIView.animate(withDuration: 0.1) { 
            view.layer.shadowColor = UIColor.clear.cgColor
        }
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
        return !states.contains(false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? NutritionDetailsViewController, let details = sender as? NutritionDetail {
            vc.fillScreen(details, recipes: self.recipes)
        } else if let vc = segue.destination as? NutritionLikeViewController {
            vc.recipes = self.recipes
        }
    }
    
    // MARK: - Action -
    @IBAction func valueChange(_ sender: Any) {
        guard let text = self.textField.text else { return }
        
        guard !text.isEmpty else {
            filteredList = self.list
            emptySearchView.isHidden = true
            return tableView.reloadData()
        }
        
        var newList: [Nutrition] = []
        for item in self.list {
            var secondList: [NutritionDetail] = []
            for second in item.list where self.isContains(pattern: text, in: "\(second.name ?? "")")  {
                secondList.append(second)
            }
            if !secondList.isEmpty {
                let someItem = Nutrition()
                someItem.name = item.name
                someItem.properties = item.properties
                someItem.list = secondList
                newList.append(someItem)
            }
        }
        tableView.scroll(to: .top, indexPath: IndexPath(row: 0, section: 0), animated: false)
        if newList.isEmpty {
            emptySearchView.isHidden = false
        } else {
            emptySearchView.isHidden = true
            filteredList = newList
            tableView.reloadData()
        }
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        
        if !cancelSearchButton.isHidden {
            UIView.animate(withDuration: 0.35, animations: {
                self.textField.text?.removeAll()
                self.rightConstraint.constant = 16
                self.cancelSearchButton.isHidden = true
                self.generalStackView.layoutIfNeeded()
            }) { (_) in
                self.filteredList = self.list
                self.emptySearchView.isHidden = true
                self.view.endEditing(true)
                self.textField.text?.removeAll()
                self.screenState = .list
                self.tableView.reloadData()
            }
        }
    }
}

extension NutritionPlanViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NutritionPlanListRowCell") as? NutritionPlanListRowCell else { fatalError() }
        cell.fillRow(nutritions: filteredList[indexPath.section].list, delegate: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: RecipesHeaderView.reuseIdentifier) as? RecipesHeaderView else {
            return UITableViewHeaderFooterView()
        }
        header.allButton.isHidden = true
        header.secondFillHeader(nutrition: list[section], delegate: self)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return isIphone5 ? 50.0 : 60.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return isIphone5 ? 150.0 : ArticleTableViewCell.rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 10 {
            addShadow(navigationContainerView)
        } else {
            deleteShadow(navigationContainerView)
        }
        if scrollView.contentOffset.y != 0 {
            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 0)
        }
    }
}

extension NutritionPlanViewController: RecipesDelegate {
    
    func showMoreClicked(title: String) {
        //
    }
//    func showArticlesList(section: Int) {
//        //
//    }
}

extension NutritionPlanViewController {
    
    @objc override func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.tableBottomConstraint.constant = keyboardHeight - (tabBarController?.tabBar.frame.height ?? 49.0)
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc override func keyboardWillHide(notification: NSNotification) {
        self.tableBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

extension NutritionPlanViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        rightConstraint.constant = 8
        cancelSearchButton.showAnimated(in: generalStackView)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        rightConstraint.constant = 16
        cancelSearchButton.hideAnimated(in: generalStackView)
    }
}

extension NutritionPlanViewController: NutritionPlanDelegate {
    
    func removeLike(nutrition: NutritionDetail?, _ button: UIButton) {
        for (index, item) in filteredList.enumerated() {
            for (secondIndex, secondItem) in item.list.enumerated() where secondItem.name == nutrition?.name {
                var keyF: String?
                for (index, item) in self.likedNutrition.enumerated() where item.name == nutrition?.name {
                    keyF = item.removeKey
                    self.likedNutrition.remove(at: index)
                    break
                }
                if let key = keyF {
                    FirebaseDBManager.saveDislikeNutritionInDataBase(key: key)
                    self.filteredList[index].list[secondIndex].removeKey = nil
                    filteredList[index].list[secondIndex].isLiked = false
                    button.setImage(#imageLiteral(resourceName: "nutrition_favorite_empty"), for: .normal)
                }
                break
            }
        }
    }
    
    func fillLike(key: String, nutrition: NutritionDetail) {
        for (index, item) in filteredList.enumerated() {
            for (secondIndex, secondItem) in item.list.enumerated() where secondItem.name == nutrition.name {
                self.filteredList[index].list[secondIndex].removeKey = key
                self.filteredList[index].list[secondIndex].isLiked = true
                self.likedNutrition.append(self.filteredList[index].list[secondIndex])
                break
            }
        }
    }
}
