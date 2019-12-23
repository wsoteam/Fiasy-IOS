//
//  ListExpertArticlesViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 11/24/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Swinject

class ListExpertArticlesViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var activityContainerView: UIView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties -
    private var expertInfo: Expert?
    private var interactor: ArticleTabInteractorInput?
    private var showBackButton: Bool = true
    private var articlesExpert: [Article] = UserInfo.sharedInstance.articleExpert
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
                
        if articlesExpert.isEmpty {
            showActivity()
            setupInteractor()
        }
        FirebaseDBManager.fetchExpertInfoInDataBase { [weak self] (info) in
            guard let strongSelf = self else { return }
            
            if let count = info?.unlockedArticles, let date = info?.date, count < 8 {
                let milisecond = Int64((Date().timeIntervalSince1970 * 1000.0).rounded())
                if milisecond >= (date + 86400000) {
                    if let id = info?.id, let count = info?.unlockedArticles {
                        FirebaseDBManager.saveExpertInfoInDataBase(id: id, count: count + 1, milisecond: Int(milisecond))
                    }
                    if let inf = info {
                        strongSelf.expertInfo = inf
                        strongSelf.expertInfo?.date = (inf.date ?? 0) + 86400000
                        strongSelf.expertInfo?.unlockedArticles = (inf.unlockedArticles ?? 0) + 1
                    }
                } else {
                    strongSelf.expertInfo = info
                }
            } else {
                strongSelf.expertInfo = info
            }
            strongSelf.setupTableView()
        }
        
        guard let _ = self.navigationView else { 
            if let _ = navigationController?.viewControllers.first as? ArticlesViewController {
                self.navigationController?.viewControllers.remove(at: 0)
            }
            return 
        }
    }
    
    func showSomeArticle(tag: Int) {
        if articlesExpert.indices.contains(tag) {
            var article: Article?
            for item in UserInfo.sharedInstance.articleExpert where item.dayInSeries == (tag + 1) {
                article = item
                break
            }
            if let arc = article {
                performSegue(withIdentifier: "sequeArticleDetailsScreen", sender: arc)
            }
        }
    }
    
    func hiddenBackButton(hidden: Bool) {
        self.showBackButton = hidden
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ArticlesDetailsViewController, let model = sender as? Article, (segue.identifier == "sequeArticleDetailsScreen") {
            vc.fillScreen(by: model)
        }
    }
    
    // MARK: - Privates -
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        tableView.register(type: ListExpertArticlesTableCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    private func setupInteractor() {
        let container = assembler.resolver as! Container
        let profileService = container.resolve(ProfileServiceProtocol.self)!
        let interactor = ArticleTabInteractor(profileService: profileService)
        interactor.output = self
        self.interactor = interactor
        interactor.loadArticleList()
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
    
    private func showActivity() {
        activityContainerView.isHidden = false
        activityIndicatorView.startAnimating()
    }
    
    private func hideActivity() {
        activityContainerView.isHidden = true
        activityIndicatorView.stopAnimating()
    }

    // MARK: - Action's -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension ListExpertArticlesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListExpertArticlesTableCell") as? ListExpertArticlesTableCell else { fatalError() }
        cell.fillCell(info: expertInfo)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let navigation = self.navigationView else { return }
        if scrollView.contentOffset.y > 0 {
            addShadow(navigation)
        } else {
            deleteShadow(navigation)
        }
    }
}

extension ListExpertArticlesViewController: ArticleTabInteractorOutput {
    
    func didLoadArticles(list: [Article]) {
        for item in list where item.category?.id == 4 {
            articlesExpert.append(item)
        }
        UserInfo.sharedInstance.articleExpert = articlesExpert
        tableView.reloadData {
            self.hideActivity()
        }
    }
}
