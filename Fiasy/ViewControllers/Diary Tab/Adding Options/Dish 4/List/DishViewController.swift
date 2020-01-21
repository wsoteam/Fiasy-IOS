//
//  DishViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 12/23/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import SwiftEntryKit

protocol DishListDelegate {
    func editProduct(_ indexPath: IndexPath)
    func removeProduct(_ indexPath: IndexPath)
}

class DishViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var blockedView: UIView!
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
    private var allDish: [Dish] = []
    private var filteredDish: [Dish] = []
    lazy var removeAlertPresetsView: TemplateAlertPresetsView = {
        guard let view = TemplateAlertPresetsView.fromXib() else { return TemplateAlertPresetsView() }
        view.removeButton.setTitle(" Блюдо удалено из списка", for: .normal)
        return view
    }()
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showActivity()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        FirebaseDBManager.fetchDishInDataBase { [weak self] (dish) in
            guard let strongSelf = self else { return }
            strongSelf.allDish = dish
            strongSelf.filteredDish = dish
            strongSelf.tableView.reloadData()
            strongSelf.emptyView.isHidden = !dish.isEmpty
            strongSelf.searchSeparatorView.isHidden = dish.isEmpty
            strongSelf.hideActivity()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editDishScreen" {
            if let vc = segue.destination as? DishCreateFirstViewController, let dish = sender as? Dish {
                vc.fillScreenByDish(dish: dish)
            }
        } else if segue.identifier == "sequeDishDetailsScreen" {
            if let vc = segue.destination as? DishDetailsViewController, let dish = sender as? Dish {
                vc.fillScreenByDish(dish: dish)
            }
        } else if segue.identifier == "sequeDishWithImageScreen" {
            if let vc = segue.destination as? DishDetailsWithImageViewController, let dish = sender as? Dish {
                vc.fillScreenByDish(dish: dish)
            }
        }
    }
    
    // MARK: - Action's -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        view.endEditing(true)
        self.textField.text?.removeAll()
        self.filteredDish = self.allDish
        self.tableView.reloadData()
        cancelSearchButton.hideAnimated(in: generalStackView)
    }
    
    @IBAction func searchValueChange(_ sender: Any) {
        guard let field = textField.text, !allDish.isEmpty else { return }
        if field.isEmpty {
            filteredDish = allDish
        } else {
            var firstItems: [Dish] = []
            for item in allDish where self.isContains(pattern: field, in: "\(item.name ?? "")") {
                firstItems.append(item)
            }
            filteredDish = firstItems
        }
        tableView.reloadData()
    }
    
    // MARK: - Private -
    private func showActivity() {
        activityView.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideActivity() {
        activityView.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func setupTableView() {
        tableView.register(type: DishListTableCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    internal func showDeleteAlert(indexPath: IndexPath) {
        if SwiftEntryKit.isCurrentlyDisplaying() {
            SwiftEntryKit.dismiss()
        } else {
            var attributes = EKAttributes()
            attributes.fillAppConfigure(height: 50.0)
            removeAlertPresetsView.fillView(delegate: self, index: indexPath)
            blockedView.isHidden = false
            SwiftEntryKit.display(entry: removeAlertPresetsView, using: attributes)
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
    
    private func showСonfirmationOfDeletion(indexPath: IndexPath) {
        let alertController = UIAlertController(title: "\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        guard let view = BasketAlertView.fromXib() else { return }
        view.titleImageView.image = #imageLiteral(resourceName: "Dish_234")
        view.descriptionLabel.text = "Вы точно хотите удалить блюдо?"
        alertController.view.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 15).isActive = true
        view.rightAnchor.constraint(equalTo: alertController.view.rightAnchor, constant: -10).isActive = true
        view.leftAnchor.constraint(equalTo: alertController.view.leftAnchor, constant: 10).isActive = true
        view.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        let removeAction = UIAlertAction(title: LS(key: .DELETE), style: .default) { [weak self] (alert) in
            guard let strongSelf = self else { return }
            strongSelf.showDeleteAlert(indexPath: indexPath)
        }
        let cancelAction = UIAlertAction(title: LS(key: .CANCEL), style: .cancel)
        cancelAction.setValue(#colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1), forKey: "titleTextColor")
        removeAction.setValue(#colorLiteral(red: 0.9231546521, green: 0.3429711461, blue: 0.342156291, alpha: 1), forKey: "titleTextColor")
        
        alertController.addAction(removeAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    private func removeDish(by key: String) {
        if allDish.count == filteredDish.count {
            var indexPath: IndexPath?
            for (index,item) in allDish.enumerated() where item.generalKey == key {
                allDish.remove(at: index)
                indexPath = IndexPath(item: index, section: 0)
            }
            filteredDish = allDish
            if let index = indexPath {
                CATransaction.begin()
                CATransaction.setCompletionBlock({
                    self.tableView.beginUpdates()
                    self.tableView.deleteRows(at: [index], with: .right)
                    self.tableView.endUpdates()
                    self.emptyView.isHidden = !self.allDish.isEmpty
                    self.searchSeparatorView.isHidden = self.allDish.isEmpty
                })
                CATransaction.commit()
            }
        } else {
            for (index,item) in allDish.enumerated() where item.generalKey == key {
                allDish.remove(at: index)
            }
            var indexPath: IndexPath?
            for (index,item) in filteredDish.enumerated() where item.generalKey == key {
                filteredDish.remove(at: index)
                indexPath = IndexPath(item: index, section: 0)
            }
            if let index = indexPath {
                CATransaction.begin()
                CATransaction.setCompletionBlock({
                    self.tableView.beginUpdates()
                    self.tableView.deleteRows(at: [index], with: .right)
                    self.tableView.endUpdates()
                    self.emptyView.isHidden = !self.allDish.isEmpty
                    self.searchSeparatorView.isHidden = self.allDish.isEmpty
                })
                CATransaction.commit()
            }
        }
    }
}

extension DishViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        cancelSearchButton.showAnimated(in: generalStackView)
    }
}

extension DishViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredDish.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DishListTableCell") as? DishListTableCell else { fatalError() }
        cell.fillCell(filteredDish[indexPath.row], delegate: self, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if filteredDish.indices.contains(indexPath.row) {
            if let _ = filteredDish[indexPath.row].imageUrl {
                performSegue(withIdentifier: "sequeDishWithImageScreen", sender: filteredDish[indexPath.row])
            } else {
                performSegue(withIdentifier: "sequeDishDetailsScreen", sender: filteredDish[indexPath.row])
            }
        }
    }
}

extension DishViewController: DishListDelegate {
    
    func editProduct(_ indexPath: IndexPath) {
        performSegue(withIdentifier: "editDishScreen", sender: filteredDish[indexPath.row])
    }
    
    func removeProduct(_ indexPath: IndexPath) {
        showСonfirmationOfDeletion(indexPath: indexPath)
    }
}

extension DishViewController: BasketDelegate {
    
    func removeProduct(indexPath: IndexPath) {
        if filteredDish.indices.contains(indexPath.row) {
            if let key = filteredDish[indexPath.row].generalKey {
                self.removeDish(by: key)
                FirebaseDBManager.removeDish(key: key)
                SwiftEntryKit.dismiss()
                self.blockedView.isHidden = true
            }
        } else {
            SwiftEntryKit.dismiss()
            self.blockedView.isHidden = true
        }
    }
    
    func cancelRemoveProduct(indexPath: IndexPath) {
        SwiftEntryKit.dismiss()
        blockedView.isHidden = true
    }
    
    func replaceProduct(newCount: Int, _ selectedPortionId: Int?) {}
}
