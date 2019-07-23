//
//  FavoritesTabViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 6/17/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class FavoritesTabViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties -
    private var itemInfo = IndicatorInfo(title: "Избранное")
    private var allFavorite: [Favorite] = []
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showActivity()
        setupTableView()
        fetchItemsInDataBase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserInfo.sharedInstance.reloadFavoriteScreen {
            UserInfo.sharedInstance.reloadFavoriteScreen = false
            showActivity()
            fetchItemsInDataBase()
        }
    }
    
    // MARK: - Private -
    private func setupTableView() {
        tableView.register(type: FavoritesProductTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fetchItemsInDataBase() {
        FirebaseDBManager.fetchFavoriteInDataBase { [weak self] (allFavorites) in
            guard let `self` = self else { return }
            self.allFavorite = allFavorites
            self.emptyView.isHidden = !allFavorites.isEmpty
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
    
    // MARK: - Action's -
    @IBAction func addProductClicked(_ sender: Any) {
        performSegue(withIdentifier: "sequeAddProductScreen", sender: nil)
    }
}

extension FavoritesTabViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allFavorite.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesProductTableViewCell") as? FavoritesProductTableViewCell else { fatalError() }
        cell.fillCell(favorite: allFavorite[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var product = Product(favorite: allFavorite[indexPath.row])
        UserInfo.sharedInstance.selectedProduct = product
        performSegue(withIdentifier: "sequeProductDetails", sender: nil)
    }
}

extension FavoritesTabViewController: IndicatorInfoProvider {
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
