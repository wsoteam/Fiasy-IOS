//
//  NutritionPlanViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 1/20/20.
//  Copyright © 2020 Eugen Lipatov. All rights reserved.
//

import UIKit

class NutritionPlanViewController: UIViewController {
    
    // MARK: - Outlet -
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
    private var list: [Nutrition] = []
    private var screenState: RecipesViewState = .list
    private let isIphone5 = Display.typeIsLike == .iphone5
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showActivity()
        screenState = .list
        textField.placeholder = LS(key: .SEARCH_FIELD_PLACEHOLDER)
        FirebaseDBManager.fetchNutritionsInDataBase { [weak self] (list) in
            guard let strongSelf = self else { return }
            strongSelf.list = list
            strongSelf.setupTableView()
            //strongSelf.tableView.reloadData()
            strongSelf.hideActivity()
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
    
    // MARK: - Privates -
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
    
    // MARK: - Action -
    @IBAction func valueChange(_ sender: Any) {
        guard let text = self.textField.text else { return }
//        guard !text.isEmpty else {
//            screenState = .list
//            filteredRecipes.removeAll()
//            return tableView.reloadData()
//        }
//        var newList: [SecondRecipe] = []
//        for item in self.allForRecipes where self.isContains(pattern: text, in: "\(item.recipeName ?? "")") {
//            newList.append(item)
//        }
//        screenState = .search
//        filteredRecipes = newList
//        tableView.reloadData()
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
}

extension NutritionPlanViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NutritionPlanListRowCell") as? NutritionPlanListRowCell else { fatalError() }
        cell.fillRow(nutritions: list[indexPath.section].list)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: RecipesHeaderView.reuseIdentifier) as? RecipesHeaderView else {
            return UITableViewHeaderFooterView()
        }
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
//        if indexPath.section == 0 {
//            if let _ = UserDefaults.standard.value(forKey: "showedExpert") {
//                performSegue(withIdentifier: "sequeSecondArticleExpertAnotherLanguage2", sender: nil)
//            } else {
//                performSegue(withIdentifier: "sequeExpertScreen", sender: nil)
//            }
//        }
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
