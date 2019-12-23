//
//  MyСreatedProductsViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 11/8/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import DropDown

protocol MyСreatedProductsDelegate {
    func editProduct(_ indexPath: IndexPath)
    func removeProduct(_ indexPath: IndexPath)
}

class MyСreatedProductsViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var addProductButton: UIButton!
    @IBOutlet weak var emptyProductsLabel: UILabel!
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var searchSeparatorView: UIView!
    @IBOutlet weak var addProductTitleLabel: UILabel!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var generalStackView: UIStackView!
    @IBOutlet weak var cancelSearchButton: UIButton!
    @IBOutlet weak var textField: DesignableUITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var progressView: CircularProgress!
    @IBOutlet weak var progressContainerView: UIView!
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityView: UIView!
    
    // MARK: - Properties -
    private var isEditSequeShow: Bool = false
    var keyboardHeight: CGFloat = 80.0
    private var dropDown = DropDown()
    private var allProducts: [Favorite] = []
    private var filteredProducts: [Favorite] = []
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showActivity()
        setupTableView()
        fetchItemsInDataBase()
        addProductTitleLabel.text = LS(key: .ADD_PRODUCT_IN_JOURNAL)
        navigationTitleLabel.text = LS(key: .MY_PRODUCTS_TITLE)
        textField.placeholder = LS(key: .SEARCH)
        cancelSearchButton.setTitle(LS(key: .CANCEL), for: .normal)
        emptyProductsLabel.text = LS(key: .MY_PRODUCT_TITLE_1)
        addProductButton.setTitle("          \(LS(key: .ADD_PRODUCT).uppercased())          ", for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configurationKeyboardNotification()
        if UserInfo.sharedInstance.reloadFavoriteScreen {
            UserInfo.sharedInstance.reloadFavoriteScreen = false
            showActivity()
            fetchItemsInDataBase()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeObserver()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sequeProductCreate" && isEditSequeShow {
            if let vc = segue.destination as? AddProductViewController, let product = sender as? Favorite {
                vc.fillEditProductFavorite(favorite: product)
            }
        } else if segue.identifier == "sequeProductDetails" {
            if let vc = segue.destination as? ProductDetailsViewController {
                if let model = sender as? Product {
                    vc.fillSelectedProduct(product: model, title: "Завтрак", basketProduct: false)
                }
            }
        }
    }
    
    // MARK: - Action's -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchValueChange(_ sender: Any) {
        guard let field = textField.text, !allProducts.isEmpty else { return }
        if field.isEmpty {
            filteredProducts = allProducts
        } else {
            var firstItems: [Favorite] = []
            for item in allProducts where self.isContains(pattern: field, in: "\(item.name ?? "")") {
                firstItems.append(item)
            }
            filteredProducts = firstItems
        }
        tableView.reloadData()
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        view.endEditing(true)
        cancelSearchButton.hideAnimated(in: generalStackView)
    }
    
    @IBAction func createProductClicked(_ sender: Any) {
        UserInfo.sharedInstance.productFlow = AddProductFlow()
        performSegue(withIdentifier: "sequeProductCreate", sender: nil)
    }
    
    // MARK: - Privates -
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        tableView.register(type: MyСreatedProductsCell.self)
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
        return states.contains(true)
    }
    
    private func showActivity() {
        activityView.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideActivity() {
        activityView.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func fetchItemsInDataBase() {
        FirebaseDBManager.fetchFavoriteInDataBase { [weak self] (allFavorites) in
            guard let `self` = self else { return }
            self.allProducts = allFavorites
            self.filteredProducts = allFavorites
            self.emptyView.isHidden = !allFavorites.isEmpty
            self.searchSeparatorView.isHidden = allFavorites.isEmpty
            self.tableView.reloadData()
            self.hideActivity()
        }
    }
    
    private func removeProduct(by key: String) {
        if allProducts.count == filteredProducts.count {
            var indexPath: IndexPath?
            for (index,item) in allProducts.enumerated() where item.key == key {
                allProducts.remove(at: index)
                indexPath = IndexPath(item: index, section: 0)
            }
            filteredProducts = allProducts
            if let index = indexPath {
                CATransaction.begin()
                CATransaction.setCompletionBlock({
                    self.tableView.beginUpdates()
                    self.tableView.deleteRows(at: [index], with: .right)
                    self.tableView.endUpdates()
                    self.emptyView.isHidden = !self.allProducts.isEmpty
                    self.searchSeparatorView.isHidden = self.allProducts.isEmpty
                })
                CATransaction.commit()
            }
        } else {
            for (index,item) in allProducts.enumerated() where item.key == key {
                allProducts.remove(at: index)
            }
            var indexPath: IndexPath?
            for (index,item) in filteredProducts.enumerated() where item.key == key {
                filteredProducts.remove(at: index)
                indexPath = IndexPath(item: index, section: 0)
            }
            if let index = indexPath {
                CATransaction.begin()
                CATransaction.setCompletionBlock({
                    self.tableView.beginUpdates()
                    self.tableView.deleteRows(at: [index], with: .right)
                    self.tableView.endUpdates()
                    self.emptyView.isHidden = !self.allProducts.isEmpty
                    self.searchSeparatorView.isHidden = self.allProducts.isEmpty
                })
                CATransaction.commit()
            }
        }
    }
}

extension MyСreatedProductsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyСreatedProductsCell") as? MyСreatedProductsCell else { fatalError() }
        cell.fillCell(filteredProducts[indexPath.row], delegate: self, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = Product(favorite: filteredProducts[indexPath.row])
        performSegue(withIdentifier: "sequeProductDetails", sender: product)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
}

extension MyСreatedProductsViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        cancelSearchButton.showAnimated(in: generalStackView)
    }
}

extension MyСreatedProductsViewController: MyСreatedProductsDelegate {
    
    func editProduct(_ indexPath: IndexPath) {
        isEditSequeShow = true
        performSegue(withIdentifier: "sequeProductCreate", sender: filteredProducts[indexPath.row])
    }
    
    func removeProduct(_ indexPath: IndexPath) {
        if filteredProducts.indices.contains(indexPath.row) {
            if let key = filteredProducts[indexPath.row].key {
                self.removeProduct(by: key)
                FirebaseDBManager.removeFavorite(key: key, handler: {
                    //self.removeProduct(by: key)
                })
            }
        }
    }
}
