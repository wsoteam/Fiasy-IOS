//
//  FavoritesTabViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 6/17/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class MyProductViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var titleNavigationView: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties -
    private var itemInfo = IndicatorInfo(title: "Свои продукты")
    private var allFavorite: [Favorite] = []
    private var filteredFavorites: [Favorite] = []
    private var selectedFavorite: Favorite?
    private var isEditSequeShow: Bool = false
    private lazy var picker: FavoritePickerService = {
        let picker = FavoritePickerService()
        picker.targetVC = self
        picker.edit = { [weak self] in
            guard let editFavorite = self?.selectedFavorite else { return }
            self?.isEditSequeShow = true
            self?.performSegue(withIdentifier: "sequeAddProductScreen", sender: nil)
        }
        
        picker.remove = { [weak self] in
            guard let key = self?.selectedFavorite?.key else { return }
            FirebaseDBManager.removeMyProduct(key: key, handler: {
                self?.removeFavorite(by: key)
            })
        }
        return picker
    }()
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showActivity()
        setupTableView()
        fetchItemsInDataBase()
        setupLongPressGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addObserver(for: self, #selector(searchByText), "searchClicked")
        if UserInfo.sharedInstance.reloadFavoriteScreen {
            UserInfo.sharedInstance.reloadFavoriteScreen = false
            showActivity()
            fetchItemsInDataBase()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeObserver()
        filteredFavorites = allFavorite
        tableView.reloadData()
    }
    
    @objc func searchByText() {
        if UserInfo.sharedInstance.searchProductText.isEmpty {
            filteredFavorites = allFavorite
        } else {
            var firstItems: [Favorite] = []
            for item in allFavorite where self.isContains(pattern: UserInfo.sharedInstance.searchProductText, in: "\(item.name ?? "")") {
                firstItems.append(item)
            }
            filteredFavorites = firstItems
        }
        tableView.reloadData()
        if filteredFavorites.isEmpty {
            AlertComponent.sharedInctance.showAlertMessage(message: "Продукт не найден", vc: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sequeAddProductScreen" && isEditSequeShow {
            if let vc = segue.destination as? AddProductViewController {
                guard let editFavorite = self.selectedFavorite else { return }
                vc.fillEditProductFavorite(favorite: editFavorite)
            }
        } else if segue.identifier == "sequeProductDetails" {
            if let vc = segue.destination as? ProductDetailsViewController {
                if let model = sender as? Product {
                    //vc.fillOwnRecipe()
                    //vc.fillSelectedProduct(product: model, title: "Завтрак", basketProduct: false)
                }
            }
        }
    }
    
    // MARK: - Private -
    private func setupTableView() {
        tableView.register(type: FavoritesProductTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupLongPressGesture() {
        let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 1.0
        longPressGesture.delegate = self
        tableView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint),
                let cell = tableView.cellForRow(at: indexPath) as? FavoritesProductTableViewCell {
                self.selectedFavorite = cell.fetchFavorite()
                picker.showPicker()
            }
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
        return states.contains(true)
    }
    
    private func fetchItemsInDataBase() {
        FirebaseDBManager.fetchMyProductInDataBase { [weak self] (allFavorites) in
            guard let `self` = self else { return }
            self.allFavorite = allFavorites
            self.filteredFavorites = allFavorites
            self.emptyView.isHidden = !allFavorites.isEmpty
            self.hideActivity()
            self.tableView.reloadData()
        }
    }
    
    private func removeFavorite(by key: String) {
        if allFavorite.count == filteredFavorites.count {
            var indexPath: IndexPath?
            for (index,item) in allFavorite.enumerated() where item.key == key {
                allFavorite.remove(at: index)
                indexPath = IndexPath(item: index, section: 0)
            }
            filteredFavorites = allFavorite
            if let index = indexPath {
                CATransaction.begin()
                CATransaction.setCompletionBlock({
                    self.tableView.beginUpdates()
                    self.tableView.deleteRows(at: [index], with: .right)
                    self.tableView.endUpdates()
                    self.emptyView.isHidden = !self.allFavorite.isEmpty
                })
                CATransaction.commit()
            }
        } else {
            for (index,item) in allFavorite.enumerated() where item.key == key {
                allFavorite.remove(at: index)
            }
            var indexPath: IndexPath?
            for (index,item) in filteredFavorites.enumerated() where item.key == key {
                filteredFavorites.remove(at: index)
                indexPath = IndexPath(item: index, section: 0)
            }
            if let index = indexPath {
                CATransaction.begin()
                CATransaction.setCompletionBlock({
                    self.tableView.beginUpdates()
                    self.tableView.deleteRows(at: [index], with: .right)
                    self.tableView.endUpdates()
                    self.emptyView.isHidden = !self.allFavorite.isEmpty
                })
                CATransaction.commit()
            }
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
        UserInfo.sharedInstance.productFlow = AddProductFlow()
        performSegue(withIdentifier: "sequeAddProductScreen", sender: nil)
    }
}

extension MyProductViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredFavorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesProductTableViewCell") as? FavoritesProductTableViewCell else { fatalError() }
        cell.fillCell(favorite: filteredFavorites[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = Product(favorite: filteredFavorites[indexPath.row])
        performSegue(withIdentifier: "sequeProductDetails", sender: product)
    }
}

extension MyProductViewController: IndicatorInfoProvider {
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}

