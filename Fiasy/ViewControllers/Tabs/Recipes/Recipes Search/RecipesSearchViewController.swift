//
//  RecipesSearchViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 6/16/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

protocol RecipesSearchDelegate {
    func changeScreenState(state: ProductAddingState)
    func searchItem(text: String)
}

class RecipesSearchViewController: UIViewController {
    
    //MARK: - Outlet's -
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomTableConstraint: NSLayoutConstraint!
    
    //MARK: - Properties -
    private var allRecipes = UserInfo.sharedInstance.allRecipes
//    private var searchRecipes = UserInfo.sharedInstance.allRecipes
    
    //MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        UserInfo.sharedInstance.selectedMealtimeData = allRecipes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configurationKeyboardNotification()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    
        removeObserver()
    }
    
    //MARK: - Properties -
    private func setupTableView() {
        tableView.register(type: RecipeMealtimeCell.self)
        tableView.register(RecipesSearchHeaderView.nib, forHeaderFooterViewReuseIdentifier: RecipesSearchHeaderView.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    //MARK: - Action's -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Private -
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
}

extension RecipesSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allRecipes.isEmpty { return 0 }
        guard allRecipes.count >= 2 else {
            return 1
        }
        return Int(round(Double(allRecipes.count/2)))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeMealtimeCell") as? RecipeMealtimeCell else { fatalError() }
        cell.fillCell(recipes: allRecipes,
                    delegate: self,
                   indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: RecipesSearchHeaderView.reuseIdentifier) as? RecipesSearchHeaderView else {
            return UITableViewHeaderFooterView()
        }
        header.fillHeader(delegate: self)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return RecipesSearchHeaderView.height
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
}

extension RecipesSearchViewController: RecipeMealtimeDelegate {
    
    func showMealtimeDetails() {
        performSegue(withIdentifier: "sequeRecipeMealtime", sender: nil)
    }
}

extension RecipesSearchViewController: RecipesSearchDelegate {
    func changeScreenState(state: ProductAddingState) {}
    
    func searchItem(text: String) {
        guard !text.isEmpty else {
            allRecipes = UserInfo.sharedInstance.allRecipes
            UserInfo.sharedInstance.selectedMealtimeData = allRecipes
            return tableView.reloadData()
        }
        
        var firstItems: [Listrecipe] = []
        for item in UserInfo.sharedInstance.allRecipes where self.isContains(pattern: text, in: "\(item.name ?? "")") {
            firstItems.append(item)
        }
        
        allRecipes = firstItems
        UserInfo.sharedInstance.selectedMealtimeData = allRecipes
        tableView.reloadData()
    }
}
