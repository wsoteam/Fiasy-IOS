//
//  SearchTabViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 6/17/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class SearchTabViewController: UIViewController {
    
    //MARK: - Outlets -
    @IBOutlet weak var bottomTableConstraint: NSLayoutConstraint!
    @IBOutlet weak var emptySearchView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties -
    private var itemInfo = IndicatorInfo(title: "Поиск")
    private var filteredProducts: [Product] = []
    
    //MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()

        filteredProducts = UserInfo.sharedInstance.allProducts
        emptySearchView.isHidden = !filteredProducts.isEmpty
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configurationKeyboardNotification()
        hideKeyboardWhenTappedAround()
        addObserver(for: self, #selector(searchByText), "searchClicked")
        
        if !UserInfo.sharedInstance.allProducts.isEmpty && UserInfo.sharedInstance.allProducts.count != filteredProducts.count {
            filteredProducts = UserInfo.sharedInstance.allProducts
            tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeObserver()
        filteredProducts = UserInfo.sharedInstance.allProducts
        tableView.reloadData()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let _ = touch.view as? UITableViewCell {
            return false
        }
        return true
    }
    
    @objc func searchByText() {
        if UserInfo.sharedInstance.searchProductText.isEmpty {
            filteredProducts = UserInfo.sharedInstance.allProducts
        } else {
            filteredProducts = SQLDatabase.shared.filter(text: UserInfo.sharedInstance.searchProductText)
        }
        tableView.reloadData()
    }

    //MARK: - Private -
    private func setupTableView() {
        tableView.register(type: SearchCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    //MARK: - Actions -
    @IBAction func addProductClicked(_ sender: UIButton) {
        
    }
}

extension SearchTabViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as? SearchCell else { fatalError() }
        
        if filteredProducts.indices.contains(indexPath.row) {
            cell.fillCell(info: filteredProducts[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if filteredProducts.indices.contains(indexPath.row) {
            UserInfo.sharedInstance.selectedProduct = filteredProducts[indexPath.row]
            performSegue(withIdentifier: "sequeProductDetails", sender: nil)
        }
    }
}

extension SearchTabViewController: IndicatorInfoProvider {
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
