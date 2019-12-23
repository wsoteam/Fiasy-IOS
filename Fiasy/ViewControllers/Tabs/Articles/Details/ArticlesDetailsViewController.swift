//
//  ArticlesDetailsViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 8/20/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Amplitude_iOS

protocol ArticlesDetailsDelegate {
    func showPremiumScreen()
}

class ArticlesDetailsViewController: UIViewController {

    // MARK: - Outlet -
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties -
    private var article: Article?
    private var currentState: Bool = UserInfo.sharedInstance.purchaseIsValid
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
//        Amplitude.instance()?.logEvent("view_articles", withEventProperties: ["articles_item" : model?.name]) // +
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addObserver(for: self, #selector(paymentComplete), Constant.PAYMENT_COMPLETE)
    }
    
    @objc func paymentComplete() {
        currentState = true
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is PremiumQuizViewController {
            let vc = segue.destination as? PremiumQuizViewController
            vc?.isAutorization = false
            vc?.trialFrom = "articles"
        } else if segue.destination is ArticlesExpertsViewController {
            let vc = segue.destination as? ArticlesExpertsViewController
            vc?.hiddenBottomContainer()
        }
    }
    
    // MARK: - Interface -
    func fillScreen(by article: Article) {
        self.article = article
    }
    
    // MARK: - Action's -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Privates -
    private func setupTableView() {
        edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 20, right: 0)
        tableView.register(type: ArticlesDetailsTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
}

extension ArticlesDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticlesDetailsTableViewCell") as? ArticlesDetailsTableViewCell else { fatalError() }
        if let article = self.article {
            cell.fillRow(article: article, premState: currentState, delegate: self)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentOffset.y > 0 else {
            return scrollView.contentOffset = CGPoint(x: 0, y: 0) }
    }
}

extension ArticlesDetailsViewController: ArticlesDetailsDelegate {
    
    func showPremiumScreen() {
        performSegue(withIdentifier: "sequePremiumScreen", sender: nil)
    }
}
