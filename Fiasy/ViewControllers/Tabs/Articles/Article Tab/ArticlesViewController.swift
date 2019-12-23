//
//  ArticlesViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 5/6/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Swinject
import Amplitude_iOS

protocol ArticlesTabDelegate {
    func showArticlesList(section: Int)
}

class ArticlesViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var tabTitleLable: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties -
    private var interactor: ArticleTabInteractorInput?
    private let isIphone5 = Display.typeIsLike == .iphone5
    private var articlesTraining: [Article] = []
    private var articlesFood: [Article] = []
    private var articlesExpert: [Article] = []
    private var allRows: [[ArticleModel]] = ArticleModel.fetchAllArticleModels()
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if getPreferredLocale().languageCode != "ru" {
            if let _ = UserDefaults.standard.value(forKey: "showedExpert") {
                performSegue(withIdentifier: "sequeSecondArticleExpertAnotherLanguage", sender: nil)
            } else {
                performSegue(withIdentifier: "sequeArticleExpertAnotherLanguage", sender: nil)
            }
        } else {
            setupTableView()
            setupInteractor()
            
            if isIphone5 {
                tabTitleLable.font = tabTitleLable.font.withSize(25)
            }
        }
    }
    
    private func getPreferredLocale() -> Locale {
        guard let preferredIdentifier = Locale.preferredLanguages.first else {
            return Locale.current
        }
        return Locale(identifier: preferredIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        allRows[0] = allRows[0].shuffled()
//        allRows[1] = allRows[1].shuffled()
//        tableView.reloadData()
//        
        Amplitude.instance()?.logEvent("choose_articles") // +
    }
    
    // MARK: - Privates -
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        tableView.register(type: NutritionistTableCell.self)
        tableView.register(type: ArticleTableViewCell.self)
        tableView.register(ArticleHeaderView.nib, forHeaderFooterViewReuseIdentifier: ArticleHeaderView.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupInteractor() {
        let container = assembler.resolver as! Container
        let profileService = container.resolve(ProfileServiceProtocol.self)!
        let interactor = ArticleTabInteractor(profileService: profileService)
        interactor.output = self
        self.interactor = interactor
        interactor.loadArticleList()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ArticlesListViewController, (segue.identifier == "sequeArticleListScreen") {
            if let array = sender as? [Article] {
                vc.fillModels(articles: array)
            }
        } else if let vc = segue.destination as? ArticlesDetailsViewController, let model = sender as? Article, (segue.identifier == "sequeArticleDetailsScreen") {
            vc.fillScreen(by: model)
        }
    }
}

extension ArticlesViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NutritionistTableCell") as? NutritionistTableCell else { fatalError() }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell") as? ArticleTableViewCell else { fatalError() }
            if indexPath.section == 1 {
                cell.fillRow(articles: articlesFood)
            } else {
                cell.fillRow(articles: articlesTraining)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section != 0 else { return nil }
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ArticleHeaderView.reuseIdentifier) as? ArticleHeaderView else {
            return UITableViewHeaderFooterView()
        }
        header.fillHeader(by: section, delegate: self)
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0001 : ArticleHeaderView.headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? UITableView.automaticDimension 
                                    : ArticleTableViewCell.rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if let _ = UserDefaults.standard.value(forKey: "showedExpert") {
                performSegue(withIdentifier: "sequeSecondArticleExpertAnotherLanguage2", sender: nil)
            } else {
                performSegue(withIdentifier: "sequeExpertScreen", sender: nil)
            }
        }
    }
}

extension ArticlesViewController: ArticlesTabDelegate {
    
    func showArticlesList(section: Int) {
        if section == 1 {
            performSegue(withIdentifier: "sequeArticleListScreen", sender: articlesFood)
        } else {
            performSegue(withIdentifier: "sequeArticleListScreen", sender: articlesTraining)
        }
        if section == 1 {
            Amplitude.instance()?.logEvent("select_diet") // +
        } else {
            Amplitude.instance()?.logEvent("select_training") // +
        }
    }
}

extension ArticlesViewController: ArticleTabInteractorOutput {
    
    func didLoadArticles(list: [Article]) {
        for item in list {
            if let id = item.category?.id {
                switch id {
                case 3:
                    articlesFood.append(item)
                case 4:
                    articlesExpert.append(item)
                default:
                    articlesTraining.append(item)
                }
            }
        }
        UserInfo.sharedInstance.articleExpert = articlesExpert
        tableView.reloadData()
    }
}
