//
//  RecipeMealtimeViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 5/6/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Amplitude_iOS

protocol RecipeMealtimeDelegate {
    func searchRecipes(name: String)
}

class RecipeMealtimeViewController: UIViewController {

    //MARK: - Outlet -
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties -
    private var screenTitle: String = ""
    private var allRecipes: [SecondRecipe] = []
    private var filterRecipes: [SecondRecipe] = []
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    //MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        navigationTitleLabel.text = screenTitle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configurationKeyboardNotification()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeObserver()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRecipeDetails" {
            if let vc = segue.destination as? RecipesDetailsViewController, let recipe = sender as? SecondRecipe {
                vc.fillScreen(by: recipe, title: screenTitle)
            }
        }
    }
    
    func fillScreen(title: String, list: [SecondRecipe]) {
        self.screenTitle = title
        self.allRecipes = list
        self.filterRecipes = list
    }
    
    //MARK: - Privates -
    private func setupTableView() {
        tableView.register(type: RecipeMealtimeCell.self)
        tableView.register(MealtimeListHeaderView.nib, forHeaderFooterViewReuseIdentifier: MealtimeListHeaderView.reuseIdentifier)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
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
    
    //MARK: - Action -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension RecipeMealtimeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeMealtimeCell") as? RecipeMealtimeCell else { fatalError() }
        cell.fillRow(recipe: filterRecipes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: MealtimeListHeaderView.reuseIdentifier) as? MealtimeListHeaderView else {
            return nil
        }
        header.fillHeader(delegate: self)
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if filterRecipes.indices.contains(indexPath.row) {
            performSegue(withIdentifier: "showRecipeDetails", sender: filterRecipes[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return MealtimeListHeaderView.height
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210.0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let header = tableView.headerView(forSection: 0) as? MealtimeListHeaderView {
            if scrollView.contentOffset.y > 0 {
                addShadow(header.searchContainerView)
            } else {
                deleteShadow(header.searchContainerView)
            }
        }
    }
}

extension RecipeMealtimeViewController: RecipeMealtimeDelegate {
    
    func searchRecipes(name: String) {
        guard !name.isEmpty else {
            filterRecipes = allRecipes
            return tableView.reloadData()
        }
        var newList: [SecondRecipe] = []
        for item in allRecipes where self.isContains(pattern: name, in: "\(item.recipeName ?? "")") {
            newList.append(item)
        }
        filterRecipes = newList
        tableView.reloadData()
    }
}
