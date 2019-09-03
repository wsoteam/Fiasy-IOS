//
//  ArticlesViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 5/6/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Intercom
import Amplitude_iOS

protocol ArticlesTabDelegate {
    func showArticlesList(section: Int)
}

class ArticlesViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var topTitleConstraint: NSLayoutConstraint!
    @IBOutlet weak var tabTitleLable: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties -
    private var selectedSection: Int = 0
    private let isIphone5 = Display.typeIsLike == .iphone5
    private var allRows: [[ArticleModel]] = ArticleModel.fetchAllArticleModels()
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        if isIphone5 {
            topTitleConstraint.constant = 20.0
            tabTitleLable.font = tabTitleLable.font.withSize(25)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Intercom.logEvent(withName: "choose_articles") //
        Amplitude.instance()?.logEvent("choose_articles") //
    }
    
    // MARK: - Privates -
    private func setupTableView() {
        tableView.register(type: ArticleTableViewCell.self)
        tableView.register(ArticleHeaderView.nib, forHeaderFooterViewReuseIdentifier: ArticleHeaderView.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ArticlesListViewController, (segue.identifier == "sequeArticleListScreen") {
            vc.fillModels(models: allRows[self.selectedSection], index: self.selectedSection)
        } else if let vc = segue.destination as? ArticlesDetailsViewController, let model = sender as? ArticleModel, (segue.identifier == "sequeArticleDetailsScreen") {
            vc.fillScreen(by: model)
        }
    }
}

extension ArticlesViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return allRows.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell") as? ArticleTableViewCell else { fatalError() }
        cell.fillRow(models: allRows[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ArticleHeaderView.reuseIdentifier) as? ArticleHeaderView else {
            return UITableViewHeaderFooterView()
        }
        header.fillHeader(by: section, delegate: self)
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return ArticleHeaderView.headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ArticleTableViewCell.rowHeight
    }
}

extension ArticlesViewController: ArticlesTabDelegate {
    
    func showArticlesList(section: Int) {
        self.selectedSection = section
        
        if section == 0 {
            Intercom.logEvent(withName: "select_diet") //
            Amplitude.instance()?.logEvent("select_diet") //
        } else {
            Intercom.logEvent(withName: "select_training") //
            Amplitude.instance()?.logEvent("select_training") //
        }

        performSegue(withIdentifier: "sequeArticleListScreen", sender: nil)
    }
}
