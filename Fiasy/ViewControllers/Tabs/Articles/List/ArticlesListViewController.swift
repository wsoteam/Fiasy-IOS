//
//  ArticlesListViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 8/20/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class ArticlesListViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var emptySearchStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Properties -
    private var titleText: String = ""
    private var articles: [Article] = []
    private var filteredArticles: [Article] = []
    private let isIphone5 = Display.typeIsLike == .iphone5
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        titleLabel.text = titleText
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configurationKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeObserver()
    }
    
    // MARK: - Action's -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Interface -
    func fillModels(articles: [Article]) {
        self.articles = articles
        self.filteredArticles = articles
        if let title = articles.first?.category?.name {
            self.titleText = title
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ArticlesDetailsViewController, let model = sender as? Article, (segue.identifier == "sequeArticleDetailsScreen") {
            vc.fillScreen(by: model)
        }
    }
    
    //MARK: - Privates -
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        tableView.register(type: ArticlesListTableViewCell.self)
        tableView.register(RecipesSearchHeaderView.nib, forHeaderFooterViewReuseIdentifier: RecipesSearchHeaderView.reuseIdentifier)
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
}

extension ArticlesListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticlesListTableViewCell") as? ArticlesListTableViewCell else { fatalError() }
        cell.fillRow(article: filteredArticles[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if filteredArticles.indices.contains(indexPath.row) {
            view.endEditing(true)
            performSegue(withIdentifier: "sequeArticleDetailsScreen", sender: filteredArticles[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: RecipesSearchHeaderView.reuseIdentifier) as? RecipesSearchHeaderView else {
            return UITableViewHeaderFooterView()
        }
        header.fillHeader(delegate: self)
        header.textField.placeholder = "Поиск по статьям"
        header.textField.tintColor = #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return RecipesSearchHeaderView.height
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
}

extension ArticlesListViewController: RecipesSearchDelegate {
    
    func changeScreenState(state: ProductAddingState) {}
    
    func searchItem(text: String) {
//        guard !text.isEmpty else {
//            filteredModels = models
//            emptySearchStackView.isHidden = true
//            tableView.isScrollEnabled = true
//            return tableView.reloadData()
//        }
//        
//        var firstItems: [ArticleModel] = []
//        for item in models where self.isContains(pattern: text, in: item.name) {
//            firstItems.append(item)
//        }
//        filteredModels = firstItems
//        emptySearchStackView.isHidden = !filteredModels.isEmpty
//        
//        if filteredModels.isEmpty {
//            tableView.isScrollEnabled = false
//        } else {
//            tableView.isScrollEnabled = true
//        }
//        tableView.reloadData()
    }
}
