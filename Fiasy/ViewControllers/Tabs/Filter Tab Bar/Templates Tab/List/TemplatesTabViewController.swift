//
//  TemplatesTabViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 6/17/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class TemplatesTabViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties -
    private var itemInfo = IndicatorInfo(title: "Шаблоны")
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showActivity()
        setupTableView()
        fetchItemsInDataBase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configurationKeyboardNotification()
        hideKeyboardWhenTappedAround()
        
        if UserInfo.sharedInstance.reloadTemplate {
            UserInfo.sharedInstance.reloadTemplate = false
            showActivity()
            fetchItemsInDataBase()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeObserver()
    }
    
    // MARK: - Action's -
    @IBAction func addTemplatesClicked(_ sender: Any) {
        post("AddTemplatesScreen")
    }
    
    // MARK: - Private -
    private func setupTableView() {
        tableView.register(type: TemplatesListCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fetchItemsInDataBase() {
        FirebaseDBManager.fetchTemplateInDataBase { [weak self] (error) in
            guard let `self` = self else { return }
            self.emptyView.isHidden = !UserInfo.sharedInstance.allTemplate.isEmpty
            self.hideActivity()
            self.tableView.reloadData()
        }
    }
    
    private func showActivity() {
        activityView.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideActivity() {
        activityView.isHidden = true
        activityIndicator.stopAnimating()
    }
}

extension TemplatesTabViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserInfo.sharedInstance.allTemplate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TemplatesListCell") as? TemplatesListCell else { fatalError() }
        cell.fillCell(UserInfo.sharedInstance.allTemplate[indexPath.row])
        return cell
    }
}

extension TemplatesTabViewController: IndicatorInfoProvider {
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
