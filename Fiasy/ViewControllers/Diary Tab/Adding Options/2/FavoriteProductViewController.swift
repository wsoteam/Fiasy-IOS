//
//  FavoriteProductViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 11/7/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import SwiftEntryKit

class FavoriteProductViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var generalStackView: UIStackView!
    @IBOutlet weak var cancelSearchButton: UIButton!
    @IBOutlet weak var textField: DesignableUITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var progressView: CircularProgress!
    @IBOutlet weak var progressContainerView: UIView!
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Properties -
    var keyboardHeight: CGFloat = 80.0
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configurationKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeObserver()
    }
    
    // MARK: - Action's -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
        tableView.register(type: ProductAddingSearchCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    func reloadBottomView() {
        if SwiftEntryKit.isCurrentlyDisplaying() {
//            var attributes = EKAttributes()
//            attributes.fillAppConfigure(height: keyboardHeight)
//            productPresetsView.fillView(count: selectedProduct.count)
//            SwiftEntryKit.display(entry: productPresetsView, using: attributes)
        }
    }
}

extension FavoriteProductViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductAddingSearchCell") as? ProductAddingSearchCell else { fatalError() }
//        cell.fillCell(product: selectedProduct[indexPath.row])
//        cell.delegate = self
        return cell
    }
}

extension FavoriteProductViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        //self.delegate?.searchItem(text: text)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        cancelSearchButton.showAnimated(in: generalStackView)
        //self.delegate?.changeScreenState(state: .search)
    }
}
