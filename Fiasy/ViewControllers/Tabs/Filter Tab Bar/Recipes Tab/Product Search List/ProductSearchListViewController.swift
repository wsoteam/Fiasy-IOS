//
//  ProductSearchListViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/16/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class ProductSearchListViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var bottomTableConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties -
    private var filteredProducts: [Product] = UserInfo.sharedInstance.allProducts
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filteredProducts = UserInfo.sharedInstance.allProducts
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configurationKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeObserver()
    }
    
    // MARK: - Action -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private -
    private func setupTableView() {
        tableView.register(type: SearchCell.self)
    }
}

extension ProductSearchListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as? SearchCell else { fatalError() }
        if filteredProducts.indices.contains(indexPath.row) {
            cell.fillProductCell(info: filteredProducts[indexPath.row])
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

extension ProductSearchListViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        if text.isEmpty {
            filteredProducts = UserInfo.sharedInstance.allProducts
        } else {
            filteredProducts = SQLDatabase.shared.filter(text: text)
        }
        tableView.reloadData()
        return true
    }
}
