//
//  RecipesViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 5/3/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Amplitude_iOS
import DynamicBlurView
import TagListView
import VisualEffectView

protocol RecipesDelegate {
    func showMoreClicked(title: String)
}

enum RecipesViewState {
    case list
    case search
}

class RecipesViewController: UIViewController {
    
    //MARK: - Outlet -
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
    
    //MARK: - Properties -
    private let isIphone5 = Display.typeIsLike == .iphone5
    private var screenState: RecipesViewState = .list
    private var allForRecipes: [SecondRecipe] = []
    private var allRecipes: [[SecondRecipe]] = []
    private var filteredRecipes: [SecondRecipe] = []
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    //MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()

        showActivity()
        screenState = .list
        textField.placeholder = LS(key: .SEARCH_FIELD_PLACEHOLDER)
        screenTitleLabel.text = LS(key: .LONG_PREM_FEATURES_RECIPE)
        cancelSearchButton.setTitle(LS(key: .CANCEL), for: .normal)
        DispatchQueue.global(qos: .background).async {
            FirebaseDBManager.fetchNewRecipesInDataBase { (recipes, allForSearch)  in
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                    self.allForRecipes = allForSearch
                    self.allRecipes = recipes
                    self.setupTableView()
                    self.hideActivity()
                })
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0,y: 0,width: 0, height: CGFloat.leastNormalMagnitude))

        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        tableView.contentInsetAdjustmentBehavior = .never
        edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
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
        if segue.identifier == "sequeRecipeMealtime" {
            if let vc = segue.destination as? RecipeMealtimeViewController, let list = sender as? [Any] {
                if let first = list.first as? String, let last = list.last as? [SecondRecipe] {
                    vc.fillScreen(title: first, list: last)
                }                
            }
        } else if segue.identifier == "sequeArticleDetailsScreen" {
            if let vc = segue.destination as? RecipesDetailsViewController, let recipe = sender as? SecondRecipe {
                var title: String = LS(key: .BREAKFAST)
                if recipe.isBreakfast {
                    title = LS(key: .BREAKFAST)
                } else if recipe.isLunch {
                    title = LS(key: .LUNCH)
                } else if recipe.isDinner {
                    title = LS(key: .DINNER)
                } else {
                    title = LS(key: .SNACK)
                }
                vc.fillScreen(by: recipe, title: title)
            }
        }
    }
    
    // MARK: - Action -
    @IBAction func valueChange(_ sender: Any) {
        guard let text = self.textField.text else { return }
        guard !text.isEmpty else {
            screenState = .list
            filteredRecipes.removeAll()
            return tableView.reloadData()
        }
        var newList: [SecondRecipe] = []
        for item in self.allForRecipes where self.isContains(pattern: text, in: "\(item.recipeName ?? "")") {
            newList.append(item)
        }
        screenState = .search
        filteredRecipes = newList
        tableView.reloadData()
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        if !cancelSearchButton.isHidden {
            UIView.animate(withDuration: 0.35, animations: {
                self.textField.text?.removeAll()
                self.rightConstraint.constant = 16
                self.cancelSearchButton.isHidden = true
                self.generalStackView.layoutIfNeeded()
            }) { (_) in
                self.view.endEditing(true)
                self.textField.text?.removeAll()
                self.screenState = .list
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Privates -
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        tableView.register(type: RecipeMealtimeCell.self)
        tableView.register(type: RecipesTableViewCell.self)
        tableView.register(RecipesHeaderView.nib, forHeaderFooterViewReuseIdentifier: RecipesHeaderView.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
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

    // MARK: - Private -
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
}

extension RecipesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return screenState == .search ? 1 : allRecipes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screenState == .search ? filteredRecipes.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if screenState == .search {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeMealtimeCell") as? RecipeMealtimeCell else { fatalError() }
            if filteredRecipes.indices.contains(indexPath.row) {
               cell.fillRow(recipe: filteredRecipes[indexPath.row]) 
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipesTableViewCell") as? RecipesTableViewCell else { fatalError() }
            if allRecipes.indices.contains(indexPath.section) {
                cell.fillRow(recipes: allRecipes[indexPath.section])
            }
            return cell 
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if screenState == .search { return nil }
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: RecipesHeaderView.reuseIdentifier) as? RecipesHeaderView else {
            return UITableViewHeaderFooterView()
        }
        header.fillHeader(by: section, delegate: self)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if screenState == .search { return 0.0001 }
        return isIphone5 ? 50.0 : RecipesHeaderView.headerHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if screenState == .search {
            if filteredRecipes.indices.contains(indexPath.row) {
                performSegue(withIdentifier: "sequeArticleDetailsScreen", sender: filteredRecipes[indexPath.row])
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return isIphone5 ? 150 : 180
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 10 {
            addShadow(navigationContainerView)
        } else {
            deleteShadow(navigationContainerView)
        }
    }
}

extension RecipesViewController: RecipesDelegate {
    
    func showMoreClicked(title: String) {
        UserInfo.sharedInstance.selectedMealtimeHeaderTitle = title
        var recipes: [SecondRecipe] = []
        var item: String = ""
        switch title {
        case LS(key: .BREAKFAST):
            item = "breakfast"
            recipes = allRecipes[0]
        case LS(key: .LUNCH):
            item = "lunch"
            recipes = allRecipes[1]
        case LS(key: .DINNER):
            item = "dinner"
            recipes = allRecipes[2]
        case LS(key: .SNACK):
            item = "snack"
            recipes = allRecipes[3]
        default:
            break
        }
        Amplitude.instance()?.logEvent("recipe_category", withEventProperties: ["recipe_category" : item]) // +
        performSegue(withIdentifier: "sequeRecipeMealtime", sender: [title, recipes])
    }
}

extension RecipesViewController: TagListViewDelegate {
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        tagView.isSelected = !tagView.isSelected
    }
}

extension RecipesViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        rightConstraint.constant = 8
        cancelSearchButton.showAnimated(in: generalStackView)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        rightConstraint.constant = 16
        cancelSearchButton.hideAnimated(in: generalStackView)
    }
}
