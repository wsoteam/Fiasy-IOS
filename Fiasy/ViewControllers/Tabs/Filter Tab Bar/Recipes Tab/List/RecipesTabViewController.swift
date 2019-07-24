//
//  RecipesTabViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 6/17/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class RecipesTabViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var bottomTableConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties -
    private var selectedRecipe: Listrecipe?
    private var isEditSequeShow: Bool = false
    private var allRecipes: [Listrecipe] = []
    private var filteredRecipes: [Listrecipe] = []
    private var itemInfo = IndicatorInfo(title: "Рецепты")
    private lazy var picker: FavoritePickerService = {
        let picker = FavoritePickerService()
        picker.targetVC = self
        picker.edit = { [weak self] in
            guard let selectedRecipe = self?.selectedRecipe else { return }
            self?.isEditSequeShow = true
            self?.performSegue(withIdentifier: "sequeAddRecipe", sender: nil)
        }
        picker.remove = { [weak self] in
            guard let key = self?.selectedRecipe?.key else { return }
            FirebaseDBManager.removeOwnRecipe(key: key, handler: {
                self?.removeRecipe(by: key)
            })
        }
        return picker
    }()
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showActivity()
        setupTableView()
        fetchItemsInDataBase()
        setupLongPressGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
 
        addObserver(for: self, #selector(searchByText), "searchClicked")
        configurationKeyboardNotification()
        if UserInfo.sharedInstance.reloadRecipesScreen {
            UserInfo.sharedInstance.reloadRecipesScreen = false
            showActivity()
            fetchItemsInDataBase()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeObserver()
    }
    
    @objc func searchByText() {
        if UserInfo.sharedInstance.searchProductText.isEmpty {
            filteredRecipes = allRecipes
        } else {
            var firstItems: [Listrecipe] = []
            for item in allRecipes where self.isContains(pattern: UserInfo.sharedInstance.searchProductText, in: "\(item.name ?? "")") {
                firstItems.append(item)
            }
            filteredRecipes = firstItems
        }
        tableView.reloadData()
        if filteredRecipes.isEmpty {
            AlertComponent.sharedInctance.showAlertMessage(message: "Рецепт не найден", vc: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sequeAddRecipe" && isEditSequeShow {
            if let vc = segue.destination as? AddRecipeViewController {
                guard let editFavorite = self.selectedRecipe else { return }
                vc.fillEditRecipe(recipe: editFavorite)
            }
        }
    }
    
    // MARK: - Private -
    private func fetchItemsInDataBase() {
        FirebaseDBManager.fetchRecipesInDataBase { [weak self] (allRecipes) in
            guard let `self` = self else { return }
            self.allRecipes = allRecipes
            self.filteredRecipes = allRecipes
            self.emptyView.isHidden = !allRecipes.isEmpty
            self.hideActivity()
            self.tableView.reloadData()
        }
    }
    
    private func removeRecipe(by key: String) {
        if allRecipes.count == filteredRecipes.count {
            var indexPath: IndexPath?
            for (index,item) in allRecipes.enumerated() where item.key == key {
                allRecipes.remove(at: index)
                indexPath = IndexPath(item: index, section: 0)
            }
            filteredRecipes = allRecipes
            if let index = indexPath {
                CATransaction.begin()
                CATransaction.setCompletionBlock({
                    self.tableView.beginUpdates()
                    self.tableView.deleteRows(at: [index], with: .right)
                    self.tableView.endUpdates()
                    self.emptyView.isHidden = !self.allRecipes.isEmpty
                })
                CATransaction.commit()
            }
        } else {
            for (index,item) in allRecipes.enumerated() where item.key == key {
                allRecipes.remove(at: index)
            } 
            var indexPath: IndexPath?
            for (index,item) in filteredRecipes.enumerated() where item.key == key {
                filteredRecipes.remove(at: index)
                indexPath = IndexPath(item: index, section: 0)
            }
            if let index = indexPath {
                CATransaction.begin()
                CATransaction.setCompletionBlock({
                    self.tableView.beginUpdates()
                    self.tableView.deleteRows(at: [index], with: .right)
                    self.tableView.endUpdates()
                    self.emptyView.isHidden = !self.allRecipes.isEmpty
                })
                CATransaction.commit()
            }
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
        return states.contains(true)
    }
    
    private func showActivity() {
        activityView.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideActivity() {
        activityView.isHidden = true
        activityIndicator.stopAnimating()
    }

    private func setupTableView() {
        tableView.register(type: RecipeTabTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupLongPressGesture() {
        let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 1.0
        longPressGesture.delegate = self
        tableView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                self.selectedRecipe = allRecipes[indexPath.row]
                picker.showPicker()
            }
        }
    }
    
    @IBAction func addRecipeClicked(_ sender: Any) {
        UserInfo.sharedInstance.recipeFlow = AddRecipeFlow()
        performSegue(withIdentifier: "sequeAddRecipe", sender: nil)
    }
}

extension RecipesTabViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTabTableViewCell") as? RecipeTabTableViewCell else { fatalError() }
        cell.fillCell(recipe: filteredRecipes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if filteredRecipes.indices.contains(indexPath.row) {
            UserInfo.sharedInstance.recipeFlow = AddRecipeFlow()
            UserInfo.sharedInstance.selectedRecipes = filteredRecipes[indexPath.row]
            performSegue(withIdentifier: "sequeResipeDetails", sender: nil)
        }
    }
}

extension RecipesTabViewController: IndicatorInfoProvider {
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}

extension RecipesTabViewController {
    
    @objc override func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.bottomTableConstraint.constant = keyboardHeight - (tabBarController?.tabBar.frame.height ?? 49.0)
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc override func keyboardWillHide(notification: NSNotification) {
        self.bottomTableConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

